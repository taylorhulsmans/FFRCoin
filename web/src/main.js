import Vue from 'vue';
import Web3 from 'web3';

import App from './App.vue';
import vuetify from './plugins/vuetify';
import router from './router';

window.addEventListener('load', () => {
  if (typeof web3 !== 'undefined') {
    console.log('Web3 injected browser: OK.')
    window.web3 = new Web3(window.web3.currentProvider)

  } else {
    console.log('Web3 injected browser: Fail. You should consider trying MetaMask.')
    
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'))    
  }
})

Vue.config.productionTip = false;
Vue.prototype.$vueEventBus = new Vue();
new Vue({
  vuetify,
  router,
  render: h => h(App)
}).$mount('#app');
