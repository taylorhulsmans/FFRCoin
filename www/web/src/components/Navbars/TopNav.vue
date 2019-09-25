<template>
  <div>
    <v-toolbar dense>
      <v-app-bar-nav-icon
        @click.stop="drawer = !drawer">
      </v-app-bar-nav-icon>
     
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
      
      <div class="flex-grow-1"></div>
      
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
   <v-navigation-drawer
          clipped
          v-model="drawer"
          style='height:100%'
        >
          <v-list
      nav
      dense
          >
      <v-list-item-group
        v-model="group"
        active-class="deep-purple--text text--accent-4"
      >
        <v-list-item>
          <v-list-item-title>Foo</v-list-item-title>
        </v-list-item>

        <v-list-item>
          <v-list-item-title>Bar</v-list-item-title>
        </v-list-item>

        <v-list-item>
          <v-list-item-title>Fizz</v-list-item-title>
        </v-list-item>

        <v-list-item>
          <v-list-item-title>Buzz</v-list-item-title>
        </v-list-item>
      </v-list-item-group>
          </v-list>
        </v-navigation-drawer>
  </div>
</template>
<script>

export default {
  data() {
    console.log(this.$router)
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
      drawer: false,
      group: null,
    }
  },
  methods: {
    go(name) {
      this.$router.push({ path: name });
    },
  },
};
</script>
