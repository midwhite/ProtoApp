<template>
  <div id="IsLoadingComponent" v-if="loading">
    <div class="loading-content">
      <i id="loading-icon" class="fa fa-spinner fa-pulse fa-3x fa-fw" @click="onClick"></i>
      <p class="loading-text">Loading</p>
    </div>
  </div>
</template>

<script>
  export default {
    props: ['loading'],
    methods: {
      onClick() { this.$store.commit('loadStop'); },
    },
  };
</script>

<style lang="scss" scoped>
  @import '../../assets/css/variables';

  #IsLoadingComponent {
    position: fixed;
    width: 100%;
    height: 100%;
    top: 0px;
    bottom: 0px;
    left: 0px;
    right: 0px;
    background: rgba(255,255,255,.7);
    z-index: 10;
    display: table-cell;
  }
  .loading-content {
    position: absolute;
    top: 0px;
    bottom: 0px;
    left: 0px;
    right: 0px;
    height: 80px;
    margin: auto;
    color: $ThemeColor;
    text-align: center;
  }
  #loading-icon {
    max-width: 80%;
    margin: auto;
  }
  .loading-text {
    margin: 10px 0px;
  }
</style>
