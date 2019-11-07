<template>
  <div>
    <v-toolbar dense>

      <v-chip
        class='ma-2'
        color='green'
        >
        <v-chip
          left
          class="green darken-4"
          >{{account.balance}}
        </v-chip>
          Balance
      </v-chip>

      <v-chip
        class='ma-2'
        color='yellow'
        text-color="black"
        >
        <v-chip
          left
          class="yellow darken-4"
          >{{account.assets}}
        </v-chip>
          assets
      </v-chip>

      <v-chip
        class='ma-2'
        color='red'
        text-color="white"
        >
        <v-chip
          left
          class="red darken-4"
          >{{account.liabilities}}
        </v-chip>
          Liabilities
      </v-chip>

       <v-chip
        class='ma-2'
        color='blue'
        text-color="white"
        >
        <v-chip
          left
          class="teal darken-4"
          >{{available}}
        </v-chip>
          Max Lend
      </v-chip>
    </v-toolbar>
  </div>
</template>
<script>
import * as FFService from '../../shared/FFService';

export default {

  data() {
    return {
      contract: null,
      account: {
        balance: null,
        liabilities: null,
        assets: null,
      },
      available: null,
    };
  },
  async created() {
    const now = new Date().getTime() / 1000;
    this.$vueEventBus.$on('sign-loan-mined', this.signLoanChange);
    this.$vueEventBus.$on('repay-loan-mined', this.repayLoanChange);
    this.contract = await FFService.getContract();
    this.addresses = await FFService.addresses();
    this.account = await FFService.getAccount(this.addresses[0]);
    this.available = await FFService.calculateAvailable(Math.floor(now + 3600 * 24 * 365));
  },
  beforeDestroy() {
    this.$vueEventBus.$off('sign-loan-mined');
    this.$vueEventBus.$off('repay-loan-mined');
  },
  methods: {
    signLoanChange(event) {
      this.account.balance += Number(event.amount);
      this.account.liabilities += Number(event.amount);
    },
    repayLoanChange(event) {
      this.account.balance -= Number(event.amount);
      this.account.liabilities -= Number(event.amount);
    },
  },
}
</script>
