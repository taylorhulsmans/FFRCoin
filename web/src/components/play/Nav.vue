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

    </v-toolbar>
  </div>
</template>
<script>
import axios from 'axios'

export default {

  data() {
    return {
      contract: null,
      balance: null

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
        let balance = await this.contract.methods.balanceOf(this.addresses[0]).call()

        console.log(balance)
        this.balance = balance
      } catch (e) {
        console.log(e)
      }
    }
  }
}
</script>
