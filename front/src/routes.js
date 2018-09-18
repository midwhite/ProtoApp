import VueRouter from 'vue-router';
import HomeComponent from '@/components/home';

const routes = [{
  path: '/', name: 'HomeComponent', component: HomeComponent,
}];

export default new VueRouter({ routes });
