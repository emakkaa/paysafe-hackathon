module.exports = {
  scan: function(successCallback, errorCallback) {
    cordova.exec(successCallback,
      errorCallback,
      "BarcodeScanner",
      "scan",
      []);
  }
};