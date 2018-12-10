<template>
  <div id="AuthComponent">
    <p class="sign-in-message">Signing in...</p>
  </div>
</template>

<script>
  import { mapActions } from 'vuex';
  import StorageService from '@/services/storage.service';

  export default {
    methods: {
      ...mapActions(['login']),
    },
    mounted() {
      // store token into LocalStorage
      const token = this.$route.query.token;
      StorageService.setToken(token);
      // display loading icon
      this.$store.commit('loadStart');
      // init login process
      this.login();
      // transit user to top page
      this.$router.push({ path: '/' });
      // display success message with snackbar
      const provider = this.$route.query.provider;
      this.$store.commit('setFlashMessage', provider + 'ログインしました');
    },
  };
</script>

<style scoped>
  .sign-in-message {
    text-align: center;
  }
</style>
