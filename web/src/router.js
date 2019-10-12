import Vue from 'vue';
import Router from 'vue-router';
import Home from './views/Home.vue';
import Play from './views/play/Play.vue';
Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home,
    },
    {
      path: '/play',
      name: 'play',
      component: Play,
    },
  ],
});
