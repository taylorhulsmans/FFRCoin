<template>
  <div>
    <MintInfo />
  <CreateMint />
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
  data: () => ({})
}
</script>
