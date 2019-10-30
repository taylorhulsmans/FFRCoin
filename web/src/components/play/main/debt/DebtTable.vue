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
    this.$vueEventBus.$on('sign-loan-mining', this.updateRow)
    this.$vueEventBus.$on('sign-loan-mined', this.updateRow)
    this.debts = await FFService.getDebts();
    this.debts = this.debts.map((debt) => {
      debt.isMining = false;
      return debt
    })
    console.log(this.debts, 'created')
  },
  beforeDestroy() {
    this.$vueEventBus.$off('new-debt-confirmed')
  },
  methods: {
    getColor (isApproved) {
      if (isApproved) return 'green';
      return 'yellow';
    },
    async updateRow(event) {
      console.log(event)
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
      })
      let iDebt = this.debts[debtIndexForSet]
      iDebt.isMining = true
      this.$set(this.debts, debtIndexForSet, iDebt)
      const signLoan = await FFService.signLoan(item.lendor, item.index)
      console.log(signLoan)
      if (!signLoan.transactionHash) {
        iDebt.isMining = false
        this.$set(this.debts, debtIndexForSet, iDebt)  
      } else {
        iDebt.isMining = false
        iDebt.isApproved = true
        this.$set(this.debts, debtIndexForSet, iDebt)
        this.$vueEventBus.$emit('sign-loan-mined', {
          amount: item.amount,
          item
        })
      }
    }
  }
};
</script>
