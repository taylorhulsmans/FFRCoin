<template>
  <div>
    <v-toolbar
      style="overflow-x:scroll"
      dense>
      
      <v-btn
        to="/">
        <v-toolbar-title>
          Fiat Frenzy
        </v-toolbar-title>
      </v-btn>

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
          link:'https://ropsten.etherscan.io/address/0xA9d0c0ad6749684dC25C2F48AC6049e77a2A2F9A'
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
