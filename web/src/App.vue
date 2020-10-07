<template>
  <v-app>
    <v-navigation-drawer
      app
      clipped
    >
      <v-list>
        <v-list-item
          v-for="i in 3"
          :key="i"
          :to="{path: '/page' + i}"
        >
          <v-list-item-action>
            <v-icon>mdi-{{ icons[i-1] }}</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>Page {{ i }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    
    <v-app-bar 
      app
      clipped-left
      prominent
    >
      <v-toolbar-title>Fiat Frenzy</v-toolbar-title>
    </v-app-bar>
    <v-content>
      <v-container fluid>
        <v-fade-transition mode="out-in">
          <!--<router-view></router-view>-->
        </v-fade-transition>
      </v-container>
    </v-content>      
  </v-app>
</template>

<script>

export default {
  name: 'App',
  data: () => ({
    drawer: false,
    icons: ['widgets', 'home', 'heart']
    //
  }),
};
</script>
