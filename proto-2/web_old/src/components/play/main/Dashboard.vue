<template>
  <v-container
    fluid
    style="margin-left: 80px">
        <v-row
          align="start"
          justify="start"
          style="height: 300px"
          
        >
        <v-card
          v-for="(card, j) in cards"
          :key="j"
          class="ma-3 pa-6"
          outlined
          tile
        >
        <h1>{{card.name}}</h1>
        </v-card>
        </v-row>
  </v-container>
</template>
<script>
export default {
  data() {
    return {
      cards: [
        {
          name: 'Seeing NaN in max lend? switch your metamask to the Ropsten Testnet'
        },
        {
          name: 'Welcome to the future home of the dashboard, where cool stats will be displayed',
        },
        {
          name: 'But no worries, we can still use the critical features.',
        },
        {
          name: 'You likely have 0 Frenz, lets get some, click on the magic wand on the left',
        },
        {
          name: 'Debts payed pack (%)',
        },
        {
          name: 'Available Funds',
        },
        {
          name: 'Minted with Gets',
        }
      ],
    };
  },
};
</script>
