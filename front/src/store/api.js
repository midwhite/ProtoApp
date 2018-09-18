import axios from 'axios';
import Storage from '@/services/storage.service';
import Constants from '@/app.constants';
import Util from '@/app.util';

export default class Api {
  static get(path, query = {}) {
    return this.request().get(path, { params: Util.camelToSnake(query) }).then(response => response.data).catch(this.onErrorHandler);
  }

  static post(path, params = {}) {
    return this.request().post(path, Util.camelToSnake(params)).then(response => response.data).catch(this.onErrorHandler);
  }

  static put(path, params = {}) {
    return this.request().put(path, Util.camelToSnake(params)).then(response => response.data).catch(this.onErrorHandler);
  }

  static delete(path, params = {}) {
    return this.request().delete(path, { params: Util.camelToSnake(params) }).then(response => response.data).catch(this.onErrorHandler);
  }

  static submit(path, form) {
    return this.request().post(path, form).then(response => response.data).catch(this.onErrorHandler);
  }

  static onErrorHandler(error) {
    return error;
  }

  static request() {
    return new axios.create({
      baseURL: Constants.ApiDomain,
      headers: { Authorization: Storage.getToken() },
    });
  }
};
