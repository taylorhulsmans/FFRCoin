<template>
  <div>
    <v-toolbar dense>
      
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
        :to="button.name" exact
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
        },
        {
          name: 'blockchain',
          symbol: 'mdi-cube-scan',
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
