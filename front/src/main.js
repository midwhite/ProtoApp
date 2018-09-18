import Vue from 'vue';
import VueRouter from 'vue-router';
import store from './store';
import router from './routes';
import App from './App.vue';
import './assets/css/global.scss';

Vue.config.productionTip = false;
Vue.use(VueRouter);

document.addEventListener('DOMContentLoaded', () => {
  const vue = new Vue({
    store,
    router,
    render: h => h(App),
  });
  vue.$mount('#app');
});
