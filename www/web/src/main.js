import Vue from 'vue';
import Web3 from 'web3';
import VueWeb3 from 'vue-web3';

import App from './App.vue';
import vuetify from './plugins/vuetify';
import router from './router';

Vue.use(VueWeb3, { web3: new Web3(web3.currentProvider ||  'ws://localhost:8546') } )
Vue.config.productionTip = false;

new Vue({
	vuetify,
	router,
  render: h => h(App)
}).$mount('#app');
