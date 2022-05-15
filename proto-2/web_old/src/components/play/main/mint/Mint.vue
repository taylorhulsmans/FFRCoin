<template>
  <div>
    <MintInfo />
  <CreateMint />
  <v-snackbar
    v-model="snackBar">
    Proof of Meme submitted, funds will be deposited shortly
  </v-snackbar>
  <v-snackbar
    v-model="mintFailed">
    Proof of Meme failed, did you already try this post?
  </v-snackbar>
  </div>
</template>
<script>


import CreateMint from './CreateMint.vue';
import MintInfo from './MintInfo.vue';

export default {
  components: {
    CreateMint,
    MintInfo,
  },
  created() {
    this.$vueEventBus.$on('mint', data => { this.showSnackBar(data) })
    this.$vueEventBus.$on('mint-failed', data => { this.showSnackBarFailed(data) })

  },
  beforeDestroy() {
    this.$vueEventBus.$off('mint')
  },
  data: () => ({
    snackBar: false,
    mintFailed: false
  }),

  methods: {
    showSnackBar(event) {
      this.snackBar = true
    },
    showSnackBarFailed(event) {
      this.mintFailed = true
    }
  },

}
</script>
