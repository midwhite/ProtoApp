<template>
  <div id="WelcomeComponent">
    <header id="header">
      <h1 class="header-title">ProtoApp</h1>
      <div class="header-menu-button">
        <img :src="require('@/assets/images/icons/menu.png')" alt="menu" class="header-menu-icon" />
      </div>
    </header>
    <div id="firstview" :style="{ backgroundImage: `url(${ require('@/assets/images/welcome/firstview.png') })` }">
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
  .header-menu-button {
    position: absolute;
    top: 0px;
    right: 0px;
    width: $HeaderHeight;
    height: $HeaderHeight;
    padding: 7px;
    cursor: pointer;
  }
  .header-menu-icon {
    max-width: 100%;
    padding: 7px;
    border: 1px solid #FFF;
    background: rgba(255,255,255,.2);
    box-shadow: 0px 0px 5px rgba(0,0,0,.5);
    transition: all .3s 0s ease;
  }
  .header-menu-icon:hover, .header-menu-icon:focus {
    background: rgba(255,255,255,.5);
    box-shadow: 0px 0px 15px rgba(0,0,0,.5);
  }
  .header-title {
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
