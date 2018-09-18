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
  </div>
</template>

<script>
  import { mapState, mapGetters, mapActions } from 'vuex';
  import HeaderComponent from '@/components/shared/header';
  import FooterComponent from '@/components/shared/footer';
  import WelcomeComponent from '@/components/welcome';
  import IsLoading from '@/components/shared/is-loading';

  export default {
    name: 'app',
    computed: {
      ...mapState(['isLoading', 'currentUser']),
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
    },
    mounted() { this.login().then(() => { this.$store.commit('loadStop'); }); },
  }
</script>

<style scoped>
</style>
