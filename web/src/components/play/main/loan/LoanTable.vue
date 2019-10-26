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
      :items="loans"
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
    </v-data-table>
  </v-card>
</template>
<script>
import * as FFService from '../../../../shared/FFService';

export default {
  data: () => ({
    newLoanMining: false,
    search: '',
    headers: [
      {
        text: 'Type',
        align: 'left',
        filterable: true,
        value: 'isApproved',
      },
      {
        text: 'Debtor',
        align: 'left',
        filterable: true,
        value: 'debtor',
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
    loans: [],
  }),
  async created() {
    this.$vueEventBus.$on('new-loan-confirmed', this.updateRow)
    this.loans = await FFService.getLoans();
  },
  beforeDestroy() {
    this.$vueEventBus.$off('new-loan-confirmed')
  },
  methods: {
    getColor (isApproved) {
      if (isApproved) return 'green';
      return 'yellow';
    },
    async updateRow(event) {
      console.log(event)
      this.newLoanMining = false
      this.loans.push({
        isApproved: false,
        debtor: event.offerLoan.events.loanOffer.returnValues._debtor,
        amount: event.amount,
        expiry: event.date,

      })

    }
  }
};
</script>
