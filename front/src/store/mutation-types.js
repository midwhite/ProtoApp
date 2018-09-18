export default {
  login(state, data) {
    state.currentUser = data.me;
  },
  setFlashMessage(state, message) {
    state.flashMessage = message;
  },
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
};
