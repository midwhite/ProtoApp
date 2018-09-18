<template>
  <modal-component @close="$emit('close')">
    <div slot="header">New User Registration</div>
    <div slot="body" id="RegistrationModalBody">
      <a :href="`${apiDomain}/v1/auth/twitter`" class="sns-login-btn twitter-color">Sign in with Twitter</a>
      <a :href="`${apiDomain}/v1/auth/facebook`" class="sns-login-btn facebook-color">Sign in with Twitter</a>
      <a :href="`${apiDomain}/v1/auth/google`" class="sns-login-btn gmail-color">Sign in with Gmail</a>
    </div>
  </modal-component>
</template>

<script>
  import ModalComponent from '@/components/shared/modal-component';
  import Constants from '@/app.constants';

  export default {
    computed: {
      apiDomain() { return Constants.ApiDomain; },
    },
    components: {
      ModalComponent,
    },
  };
</script>

<style scoped>
  #RegistrationModalBody .sns-login-btn {
    padding: 8px;
    margin: 10px 0px;
    color: #FFF;
    font-size: 18px;
    text-align: center;
    box-shadow: 0px 0px 10px rgba(0,0,0,.5);
    display: block;
  }
</style>
