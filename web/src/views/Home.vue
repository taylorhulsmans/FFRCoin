/* es-lint-disable */
<template>
  <v-app id="home">
  </v-app>
</template>
<script>
export default {
  components: {
  },

  data: () => ({
    phi: (1 + Math.sqrt(5)) / 2,
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
