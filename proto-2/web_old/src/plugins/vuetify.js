import Vue from 'vue';
import Vuetify from 'vuetify/lib';
import 'vue-cli-plugin-vuetify-preset-rally/preset'

Vue.use(Vuetify);

export default new Vuetify({
  preset: 'vue-cli-plugin-vuetify-preset-rally/preset',
  theme: {
    dark: false,
  },
  icons: {
    iconfont: 'mdi',
  },
});
