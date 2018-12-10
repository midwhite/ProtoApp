<template>
  <div id="app" class="container-fluid">
    <div id="Welcome" v-if="!isSignedIn">
      <welcome-component />
    </div>
    <div v-else>
      <header-component />
      <router-view />
      <footer-component />
    </div>
    <is-loading :loading="isLoading" />
    <snackbar v-if="flashMessage" />
  </div>
</template>

<script>
  import { mapState, mapActions } from 'vuex';
  import HeaderComponent from '@/components/shared/header';
  import FooterComponent from '@/components/shared/footer';
  import WelcomeComponent from '@/components/welcome';
  import IsLoading from '@/components/shared/is-loading';
  import Snackbar from '@/components/shared/snackbar';

  export default {
    name: 'app',
    computed: {
      ...mapState(['isLoading', 'currentUser', 'flashMessage']),
      isSignedIn() { return !!this.currentUser; },
    },
    methods: {
      ...mapActions(['login']),
    },
    components: {
      HeaderComponent,
      FooterComponent,
      WelcomeComponent,
      IsLoading,
      Snackbar,
    },
    mounted() { this.login().then(() => { this.$store.commit('loadStop'); }); },
  }
</script>

<style scoped>
</style>
