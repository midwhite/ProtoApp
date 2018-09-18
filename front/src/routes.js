import VueRouter from 'vue-router';
import HomeComponent from '@/components/home';
import AuthComponent from '@/components/auth';

const routes = [{
  path: '/', name: 'Home', component: HomeComponent,
}, {
  path: '/auth/callback', name: 'AuthComponent', component: AuthComponent,
}];

export default new VueRouter({ routes, mode: 'history' });
