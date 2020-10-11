<template>
  <v-app
    class="background"
    :style="{'background-image':'url(' + require('@/assets/background.jpeg')}"
    >

    <v-app-bar
      app
      clipped-left
      prominent
      shrink-on-scroll
      scroll-tartet="#scrolling-techniques-3"
    >
          <template v-slot:img="{ props }">
        <v-img
          v-bind="props"
          gradient="to top right, rgba(220,220,220,.7), rgba(255,255,255,.7)"
        ></v-img>
      </template>
    <v-toolbar-title class="pl-11"><i>Welcome,</i> to FREN</v-toolbar-title>
    <template v-slot:extension>
      <v-tabs align-with-title>
        <v-tab
          v-for="(tab, i) of tabs"
          :key="i"
          :to="tab.path"
          > 
            <v-icon>{{tab.icon}}</v-icon> {{tab.title}}
        </v-tab>
      </v-tabs>
    </template>
    </v-app-bar>
    <v-content>
      <v-container fluid>
        <v-fade-transition mode="out-in">
          <router-view></router-view>
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
    tabs: [
      {
        path: '/',
        icon: 'mdi-home-outline',
        title: 'Home'
      },
      {
        path: 'docs',
        icon: 'mdi-text-box-search-outline',
        title: 'Docs'
      },
      {
        path: 'faq',
        icon: 'mdi-map-marker-question-outline',
        title: 'FAQ'
      },
      {
        path: 'play',
        icon: 'mdi-open-in-new',
        title: 'App'
      },
    ],
    icons: ['widgets', 'home', 'heart']
    //
  }),
};
</script>
<style>
</style>
