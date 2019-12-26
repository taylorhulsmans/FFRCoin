<template>
  <v-app id="home">
    <TopNav />
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
import TopNav from '../components/TopNav.vue';
import SideNav from '../components/home/SideNav.vue';
import FractionalReserves from '../components/home/FractionalReserves.vue';
import About from '../components/home/About.vue';
export default {
  components: {
    TopNav,
    SideNav,
    FractionalReserves,
    About,
  },

  data: () => ({
    phi: (1 + Math.sqrt(5)) / 2,
    main: About,
  }),
  methods: {
    changeDashboard($event) {
      this.main = this.$options.components[$event]
    },
  },
};
</script>
<style>
.theme--dark.v-application {
  color: gainsboro;
}

</style>
