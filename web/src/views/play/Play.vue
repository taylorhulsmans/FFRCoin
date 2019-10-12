<template>
<div> 
  <TopNav>
  </TopNav>
  <SideNav>
  </SideNav>
</div>
</template>
<script>
import SideNav from '../../components/play/SideNav.vue';
import TopNav from '../../components/TopNav.vue';
export default {
  components: {
    TopNav,
    SideNav,
  },

  data: () => ({
    child_component: 'playNav',
  }),
};
</script>
