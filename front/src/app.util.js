export default class Util {
  static camelToSnake(params) {
    const snakeParams = {};
    Object.keys(params).forEach(key => {
      if (Array.isArray(params[key])) {
        params[key].forEach((element, i) => {
          if (typeof element === 'object' && element !== null) {
            params[key][i] = Util.camelToSnake(element);
          }
        });
      } else if (typeof params[key] === 'object' && params[key] !== null) {
        params[key] = Util.camelToSnake(params[key]);
      }
      const newKey = key.replace(/([A-Z])/g, s => '_' + s.charAt(0).toLowerCase());
      snakeParams[newKey] = params[key];
    });
    return snakeParams;
  }

  static randomNum(max) {
    return Math.floor(Math.random() * max);
  }

  static randomStr(length) {
    const result = [];
    const string = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_';
    for (let i = 0; i < length; i++) {
      const index = Util.randomNum(string.length);
      result.push(string.substr(index, 1));
    }
    return result.join('');
  }

  static parseQuery(queryString) {
    const result = {};
    const index = queryString.indexOf('?');
    const query = (index !== 0) ? queryString.substr(index + 1) : queryString;
    query.split('&').forEach(string => {
      const pair = string.split('=');
      const key = pair[0];
      const value = pair[1];
      if (key && value) { result[key] = decodeURIComponent(value); }
    });
    return result;
  }
}
