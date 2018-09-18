import Vue from 'vue';
import Vuex from 'vuex';
import actions from './action-types';
import mutations from './mutation-types';

Vue.use(Vuex);

const state = {};

const getters = {};

export default new Vuex.Store({
  state,
  getters,
  actions,
  mutations,
});