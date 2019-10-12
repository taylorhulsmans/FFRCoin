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
          >{{balance}}
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
          >{{assets}}
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
          >{{liabilities}}
        </v-avatar>
          Liabilities
      </v-chip>


    </v-toolbar>
  </div>
</template>
<script>
import axios from 'axios'

export default {

  data() {
    return {
      contract: null,
      balance: null,
      liabilities: null,
      assets: null

    }
  },
  async created() {
    this.contract = await this.getContract();
    this.addresses = await this.addresses();
    this.account = await this.getBalances();
  },

  methods: {
    async getContract() {
      let contractData = null;
      try {
        contractData = await axios.get('api/contract');
      } catch (e) {
        console.log(e)
        return e
      }
      const { address } = contractData.data;
      const { abi } = contractData.data.FiatFrenzy;
      return new window.web3.eth.Contract(abi, address)
    },
    async addresses() {
      try {
        return await window.ethereum.enable()
      } catch (e) {
        console.log(e)
        return e
      }
    },
    async getBalances() {
      try {
        const balance = await this.contract.methods.balanceOf(this.addresses[0]).call();
        const liabilities = await this.contract.methods.liabilitiesOf(this.addresses[0]).call();
        const assets = await this.contract.methods.assetsOf(this.addresses[0]).call();

        this.balance = balance
        this.liabilities = liabilities
        this.assets = assets
      } catch (e) {
        console.log(e)
      }
    }
  }
}
</script>
