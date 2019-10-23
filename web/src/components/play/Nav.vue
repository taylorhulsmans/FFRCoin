<template>
  <div>
    <v-toolbar dense>
      <v-toolbar-title>
        Dashboard
      </v-toolbar-title>

      <v-chip
        class='ma-2'
        color='green'
        >
        <v-avatar
          left
          class="green darken-4"
          >{{account.balance}}
        </v-avatar>
          Balance
      </v-chip>

      <v-chip
        class='ma-2'
        color='yellow'
        text-color="black"
        >
        <v-avatar
          left
          class="yellow darken-4"
          >{{account.assets}}
        </v-avatar>
          assets
      </v-chip>

      <v-chip
        class='ma-2'
        color='red'
        text-color="white"
        >
        <v-avatar
          left
          class="red darken-4"
          >{{account.liabilities}}
        </v-avatar>
          Liabilities
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
    };
  },
  async created() {
    this.contract = await FFService.getContract();
    this.addresses = await FFService.addresses();
    this.account = await FFService.getAccount(this.addresses[0]);
  },
}
</script>
