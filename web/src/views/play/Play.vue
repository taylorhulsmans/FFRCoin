<template>
<v-app id="app">
  <TopNav>
  </TopNav>
  <SideNav
    v-on:change-main="changeDashboard"
  />
  <component
   style="margin-left: 80px"
   :is="main"
  />
</v-app>
</template>
<script>

import TopNav from '../../components/TopNav.vue';
import SideNav from '../../components/play/SideNav.vue';
import Loans from '../../components/play/main/loan/Loans.vue';
import Dashboard from '../../components/play/main/Dashboard.vue';

export default {
  components: {
    TopNav,
    SideNav,
    Dashboard,
    Loans,

  },

  data: () => ({
    main: Dashboard,

  }),

  methods: {
    changeDashboard($event) {
      this.main = this.$options.components[$event]
    },
  }
};
</script>
