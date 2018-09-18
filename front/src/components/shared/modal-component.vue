<template>
  <transition name="modal">
    <div class="modal-mask">
      <div class="modal-wrapper" @click.self="$emit('close')">
        <div class="modal-container">

          <div class="modal-header">
            <slot name="header"></slot>
          </div>

          <div class="modal-body">
            <slot name="body"></slot>
          </div>

          <div class="modal-footer">
            <slot name="footer">
              <button class="btn modal-default-button" @click="$emit('close')">OK</button>
            </slot>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<style lang="scss" scoped>
  @import '@/assets/css/variables.scss';

  .modal-header {
    padding: 0px 0px 10px;
    margin: 0px;
    font-size: 14px;
    font-weight: bold;
  }

  .modal-body {
    padding: 0px;
    margin: 10px 0px;
    font-size: 14px;
  }

  .modal-footer {
    padding: 10px 0px 0px;
    margin: 0px;
  }

  /* Basic Style */
  .modal-mask {
    position: fixed;
    z-index: 9998;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, .5);
    display: table;
    transition: opacity .3s ease;
  }

  .modal-wrapper {
    display: table-cell;
    vertical-align: middle;
  }

  .modal-container {
    width: 300px;
    max-height: 80%;
    margin: 0px auto;
    padding: 20px 30px;
    border-radius: 2px;
    background: #fff;
    font-family: Helvetica, Arial, sans-serif;
    box-shadow: 0 2px 8px rgba(0, 0, 0, .33);
    transition: all .3s ease;
    overflow-y: scroll;
  }

  .modal-default-button {
    float: right;
    min-width: 100px;
    background: $ThemeColor;
    color: #FFF;
    box-shadow: 0px 0px 10px rgba(0,0,0,.5);
  }

  /* Animation */
  .modal-enter {
    opacity: 0;
  }

  .modal-leave-active {
    opacity: 0;
  }

  .modal-enter .modal-container,
  .modal-leave-active .modal-container {
    -webkit-transform: scale(1.1);
    transform: scale(1.1);
  }
</style>
