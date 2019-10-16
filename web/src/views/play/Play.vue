<template>
<v-app id="app"> 
  <TopNav>
  </TopNav>
  <SideNav
    v-on:change-main="changeMain" />
  <component :is="main" />
</v-app>
</template>
<script>
import SideNav from '../../components/play/SideNav.vue';
import TopNav from '../../components/TopNav.vue';
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
    changeMain($event) {
      this.main = this.$options.components[$event]
    },
  }
};
</script>
