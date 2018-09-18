<template>
  <div id="WelcomeComponent">
    <header id="header">
      <h1 class="heder-title">ProtoApp</h1>
    </header>
    <div id="firstview" :style="{ backgroundImage: `url(${ require('@/assets/images/firstview.png') })` }">
    </div>
  </div>
</template>

<script>
  export default {};
</script>

<style lang="scss" scoped>
  @import '@/assets/css/variables.scss';

  #header {
    position: fixed;
    top: 0px;
    left: 0px;
    bottom: 0px;
    right: 0px;
    height: $HeaderHeight;
    background: $ThemeColor;
    color: #FFF;
    text-align: center;
    box-shadow: 0px 0px 10px rgba(0,0,0,.5);
  }
  .heder-title {
    margin: 0px;
    line-height: $HeaderHeight;
  }
  #firstview {
    min-height: 300px;
    margin: $HeaderHeight -15px 0px;
    background-color: rgba(0,0,0,.04);
    background-size: 60px;
    background-position: center;
    background-repeat: no-repeat;
  }
</style>
