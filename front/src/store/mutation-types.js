export default {
  loadStart(state) {
    state.isLoading = true;
  },
  loadStop(state) {
    state.isLoading = false;
  },
  toggleLoading(state, isLoading) {
    if (typeof isLoading === 'undefined') {
      state.isLoading = !state.isLoading;
    } else {
      state.isLoading = isLoading;
    }
  },
  login(state, data) {
    state.currentUser = data.me;
  },
};
