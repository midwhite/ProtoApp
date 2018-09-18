import api from './api';

export default {
  login({ commit }) {
    return api.get('/v1/auth/me').then(data => {
      commit('login', data);
    });
  },
};
