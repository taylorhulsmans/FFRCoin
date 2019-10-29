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
          v-if="!item.isApproved"
          @click="signLoan(item.lendor, item.index)">
          mdi-pencil
        </v-icon>
      </template>
    </v-data-table>
  </v-card>
</template>
<script>
import * as FFService from '../../../../shared/FFService';

export default {
  data: () => ({
    newDebtMining: false,
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
    this.$vueEventBus.$on('new-debt-confirmed', this.updateRow)
    this.debts = await FFService.getDebts();
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
      this.newDebtMining = false
      this.debts.push({
        isApproved: false,
        debtor: event.offerDebt.events.debtOffer.returnValues._debtor,
        amount: event.amount,
        expiry: event.date,

      })

    },
    async signLoan(lendor, index) {
      return FFService.signLoan(lendor, index)
    }
  }
};
</script>
