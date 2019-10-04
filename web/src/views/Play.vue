<template>
    <TopNav>
    </TopNav>
</template>
<script>
import TopNav from '../components/TopNav.vue';
export default {
  components: {
    TopNav,
  },

  data: () => ({
    child_component: 'playNav',
  }),
};
</script>
