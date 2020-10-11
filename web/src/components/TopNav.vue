<template>
  <div>
    <v-toolbar
      style="overflow-x:scroll"
      dense>
      <v-btn icon
        v-for="button in leftNav"
        :key="button.name"
        :to="button.name" exact
        active-class="highlighted"
        :class="button.name === $route.path ?
          'highlighted':
          ''
        ">
        <v-icon>{{button.symbol}}</v-icon>
      </v-btn>

      <div class="flex-grow-1">
        <PlayNav v-if="$route.path == '/play'"/>
      </div>

      <v-btn icon
        v-for="button in rightNav"
        :key="button.name"
        :href="button.link"
        target="_blank"
        active-class="highlighted"
        :class="button.name === $route.path ?
          'highlighted':
          ''
          ">
            <v-icon>{{button.symbol}}</v-icon>
      </v-btn>

    </v-toolbar>
  </div>
</template>
<script>
import PlayNav from './play/Nav.vue';
export default {
  components: {
    PlayNav
  },
  beforeCreated() {
    console.log('topnav')
    window.addEventListener('load', () => {
      if (typeof web3 !== 'undefined') {
        console.log('Web3 injected browser: OK.')
        window.web3 = new Web3(window.web3.currentProvider)

      } else {
        console.log('Web3 injected browser: Fail. You should consider trying MetaMask.')
        
        // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
        window.web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'))    
      }
    })
  },
  data() {
    return {
      leftNav: [
        {
          name: 'play',
          symbol: 'mdi-play-circle-outline',
        },
        {
          name: 'leaderboard',
          symbol: 'mdi-trophy-outline',
        },
      ],
      rightNav: [
        {
          name: 'github',
          symbol: 'mdi-github-circle',
          link: 'https://github.com/Joe-mcgee/Fiat-Frenzy-777'
        },
        {
          name: 'blockchain',
          symbol: 'mdi-cube-scan',
          link: 'https://ropsten.etherscan.io/address/0x9DBfc1928bA12172b65D46A84c80df3388EdD36a'
        },
        {
          name: 'search',
          symbol: 'mdi-magnify',
        },
        {
          name: 'account',
          symbol: 'mdi-account',
        }


      ],
      group: null,
    }
  },
  methods: {
  },
};
</script>
<style>
::-webkit-scrollbar {
  width: 0px;
  height: 0px;
  background: transparent;
}
</style>
