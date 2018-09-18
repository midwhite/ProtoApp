import Constants from '@/app.constants';
import Util from '@/app.util';

class PrivateStorageService {
  static privateStorage;

  static setPrivateStorage() {
    if (typeof this.privateStorage === 'undefined') {
      this.privateStorage = {};
    }
  }

  static getValue(key) {
    this.setPrivateStorage();
    return localStorage.getItem(key) || this.privateStorage[key];
  }

  static save(key, value) {
    this.setPrivateStorage();
    try {
      localStorage.setItem(key, value);
    } catch (e) {
      // silence error in case user uses private mode browser
      this.privateStorage[key] = value;
    }
  }

  static remove(key) {
    this.setPrivateStorage();
    localStorage.removeItem(key);
    // in case user uses private mode browser
    delete this.privateStorage[key];
  }
}

export default class StorageService {
  static getToken() {
    return PrivateStorageService.getValue(Constants.TokenKey);
  }

  static setToken(token) {
    PrivateStorageService.save(Constants.TokenKey, token);
  }

  static removeToken() {
    PrivateStorageService.remove(Constants.TokenKey);
  }

  static getBrowserId() {
    return PrivateStorageService.getValue(Constants.BrowserKey);
  }

  static setBrowserId() {
    const browserId = Util.randomStr(16);
    PrivateStorageService.save(Constants.BrowserKey, browserId);
  }

  static getLocale() {
    return PrivateStorageService.getValue(Constants.LocaleKey);
  }

  static setLocale(locale) {
    PrivateStorageService.save(Constants.LocaleKey, locale);
  }
}
