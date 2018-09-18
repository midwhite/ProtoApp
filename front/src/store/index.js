import Vue from 'vue';
import Vuex from 'vuex';
import actions from './action-types';
import mutations from './mutation-types';

Vue.use(Vuex);

const state = {
  isLoading: true,
  currentUser: null,
};

const getters = {
  isSignedIn(state) { return !!state.currentUser; }
};

export default new Vuex.Store({
  state,
  getters,
  actions,
  mutations,
});