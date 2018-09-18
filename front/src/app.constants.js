export default class Constants {
  static get Env() { return process.env.NODE_ENV; }
  static get TokenKey() { return 'proto/token'; }
  static get BrowserKey() { return 'proto/browserId'; }
  static get LocaleKey() { return 'proto/locale'; }
  static get ApiDomain() { return this.Env === 'development' ? 'https://localhost:9292' : 'https://proto-app.com'; }
};
