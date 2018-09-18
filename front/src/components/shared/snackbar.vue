<template>
  <div :class="{ 'snackbar-component': true, show: !!flashMessage }">
    {{ flashMessage }}
  </div>
</template>

<script>
  import { mapState, mapMutations } from 'vuex';

  export default {
    computed: {
      ...mapState(['flashMessage']),
    },
    methods: {
      ...mapMutations(['setFlashMessage']),
    },
    mounted() { setTimeout(() => { this.setFlashMessage(null); }, 2850); },
  }
</script>

<style lang="scss" scoped>
  @import '../../assets/css/variables';

  .snackbar-component {
    position: fixed;
    left: 30px;
    right: 30px;
    top: 30px;
    min-width: 250px;
    padding: 16px;
    border-radius: 2px;
    background-color: #333;
    color: #fff;
    text-align: center;
    z-index: 2;
    visibility: hidden;
  }

  .snackbar-component.show {
    visibility: visible;
    -webkit-animation: fadein 0.5s, fadeout 0.5s 2.5s;
    animation: fadein 0.5s, fadeout 0.5s 2.5s;
  }

  @-webkit-keyframes fadein {
    from { top: 0; opacity: 0; }
    to { top: 30px; opacity: 1; }
  }

  @keyframes fadein {
    from { top: 0; opacity: 0; }
    to { top: 30px; opacity: 1; }
  }

  @-webkit-keyframes fadeout {
    from { top: 30px; opacity: 1; } 
    to { top: 0; opacity: 0; }
  }

  @keyframes fadeout {
    from { top: 30px; opacity: 1;}
    to { top: 0; opacity: 0;}
  }
</style>
