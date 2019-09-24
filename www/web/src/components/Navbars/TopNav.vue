<template>
  <div>
    <v-toolbar dense>
      <v-app-bar-nav-icon
        @click.stop="drawer = !drawer">
      </v-app-bar-nav-icon>
     
      <v-toolbar-title>Fiat Frenzy</v-toolbar-title>
      
      <v-btn icon>
        <v-icon>mdi-play-circle-outline</v-icon>
      </v-btn>
      
      <v-btn icon>
        <v-icon>mdi-trophy-outline</v-icon>
      </v-btn>

      <div class="flex-grow-1"></div>
      
      <v-btn icon>
        <v-icon>mdi-cube-scan</v-icon>
      </v-btn>

      <v-btn icon>
        <v-icon>mdi-github-circle</v-icon>
      </v-btn>

      <v-btn icon>
        <v-icon>mdi-account</v-icon>
      </v-btn>
      
      <v-btn icon>
        <v-icon>mdi-magnify</v-icon>
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
  data: () => ({
    drawer: false,
    group: null,
  }),
};
</script>
