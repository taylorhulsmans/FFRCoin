<template>
  <v-card>
    <v-card-title>
      <v-text-field
        v-model="search"
        append-icon="search"
        label="Search"
        single-line
        hide-details
      ></v-text-field>
    </v-card-title>
    <v-data-table
      :headers="headers"
      :items="debts"
      :search="search"
    >
      <template v-slot:item.isApproved="{ item }">
        <v-chip
          v-if="item.amount > 0"
          :color="getColor(item.isApproved)"
          dark
          text-color="black"
        >
          {{
            item.isApproved ?
              'Approved':
              'Unapproved'
          }}
        </v-chip>
        <v-chip
          v-else
          color="blue"
          dark
        >
        Repaid
        </v-chip>
      </template>

      <template v-slot:item.actions="{ item }">
        <v-icon
          v-if="!item.isApproved && !item.isMining"
          @click="signLoan(item)">
          mdi-pencil
        </v-icon>
        <v-progress-circular
          v-if="item.isMining"
          indeterminate
          color="amber"
        >
        </v-progress-circular>

        <v-icon
          v-if="
            item.isApproved &&
            !item.isMining &&
            item.amount > 0"
          @click="repayLoan(item)"
        >
        mdi-cash-refund
        </v-icon>
      </template>
    </v-data-table>
  </v-card>
</template>
<script>
import * as FFService from '../../../../shared/FFService';

export default {
  data: () => ({
    signLoanMining: false,
    search: '',
    headers: [
      {
        text: 'Type',
        align: 'left',
        filterable: true,
        value: 'isApproved',
      },
      {
        text: 'Lendor',
        align: 'left',
        filterable: true,
        value: 'lendor',
      },
      {
        text: 'Amount',
        align: 'left',
        filterable: true,
        value: 'amount',
      },
      {
        text: 'Interest',
        align: 'left',
        filterable: true,
        value: 'interest',
      },
      {
        text: 'Date',
        align: 'left',
        filterable: true,
        value: 'expiry',
      },
      {
        text: 'Action',
        align: 'left',
        filterable: true,
        value: 'actions',
      },
    ],
    debts: [],
  }),
  async created() {
    this.$vueEventBus.$on('sign-loan-mining', this.updateRow);
    this.$vueEventBus.$on('sign-loan-mined', this.updateRow);
    this.debts = await FFService.getDebts();
    this.debts = this.debts.map((debt) => {
      debt.isMining = false;
      return debt
    })
  },
  beforeDestroy() {
    this.$vueEventBus.$off('new-debt-confirmed')
    this.$vueEventBus.$off('sign-loan-mining')
    this.$vueEventBus.$off('sign-loan-mined')
  },
  methods: {
    getColor (isApproved) {
      if (isApproved) return 'green';
      return 'yellow';
    },
    async updateRow(event) {
    },
    async signLoan(item) {
      this.$vueEventBus.$emit('sign-loan-mining')
      let debtIndexForSet = null
      let state = this.debts.find((debt, i) => {
        if (debt.index === item.index && debt.lendor === item.lendor) {
          debtIndexForSet = i
          return true
        }
        return false
      });
      const iDebt = this.debts[debtIndexForSet];
      iDebt.isMining = true;
      this.$set(this.debts, debtIndexForSet, iDebt);
      const signLoan = await FFService.signLoan(item.lendor, item.index);
      if (!signLoan.transactionHash) {
        iDebt.isMining = false;
        this.$set(this.debts, debtIndexForSet, iDebt);
      } else {
        iDebt.isMining = false;
        iDebt.isApproved = true;
        this.$set(this.debts, debtIndexForSet, iDebt);
        this.$vueEventBus.$emit('sign-loan-mined', {
          amount: Number(item.amount),
          interest: Number(item.interest),
          item,
        });
      }
    },
    async repayLoan(item) {
      let itemIterator = null;
      this.debts.find((debt, i) => {
        if (debt.index === item.index && debt.lendor === item.lendor) {
          itemIterator = i;
          return true;
        }
        return false;
      })
      let iDebt = this.debts[itemIterator]
      console.log(iDebt)
      iDebt.isMining = true
      this.$set(this.debts, itemIterator, iDebt)
      const repayLoan = await FFService.repayLoan(item.lendor, item.index)
      if (!repayLoan.transactionHash) {
        iDebt.isMining = false
        this.$set(this.debts, itemIterator, iDebt)
      } else {
        this.$vueEventBus.$emit('repay-loan-mined', {amount: Number(item.amount), interest: Number(item.interest)})
        iDebt.isMining = false
        iDebt.amount = 0
        this.$set(this.debts, itemIterator, iDebt)
      }



      
    },
  },
};
</script>
