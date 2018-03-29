angular.module('cents.ui' , ['cents.ui.custom-square']);
angular.module('cents.home', ['cents.home.controller']);
angular.module('cents.auth.login', ['cents.auth.login.controller']);
angular.module('cents.auth.forgotten-password', ['cents.auth.forgotten-password.controller']);
angular.module('cents.auth.change-password', ['cents.auth.change-password.controller']);
angular.module('cents.auth.account-conformation', ['cents.auth.account-confirmation.controller']);
angular.module('cents.auth.signup', ['cents.auth.signup.controller', 'cents.auth.signup.service']);
angular.module('cents.auth', ['cents.auth.service','cents.auth.signup','cents.auth.jwt-service', 'cents.auth.account-conformation',
  'cents.auth.login', 'cents.auth.forgotten-password', 'cents.auth.change-password']);
angular.module('cents', ['ionic', 'ngRoute', 'ngAnimate', 'ngCordova','ngCordovaOauth', 'angular-jwt', 'pascalprecht.translate',
  'cents.home'])

.run(function($ionicPlatform, $rootScope, $state, $ionicPopup, $window) {
  $ionicPlatform.ready(function() {
    if (window.cordova && window.cordova.plugins && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(false);
      cordova.plugins.Keyboard.disableScroll(true);
    }
    if (window.StatusBar) {
      StatusBar.styleDefault();
    }
    if (ionic.Platform.isIOS()) {
      ionic.Platform.fullScreen(true, true);
    }
    if (window.Connection) {
      if (navigator.connection.type == Connection.NONE) {
        $ionicPopup.alert({
          title: "Internet Disconnected",
          template: "The internet is disconnected on your device.",
          okText: 'Try again',
          okType: 'btn-no-internet'
        }).then(function(res) {
          $window.location.reload();
        });
      } else {
        //ServerConfig.loadConfigurations();
      }
    } else {
      //ServerConfig.loadConfigurations();
    }
    $state.go('home');
  });
})

.config(function($stateProvider, $urlRouterProvider, $ionicConfigProvider) {

  $ionicConfigProvider.views.swipeBackEnabled(true);
  $ionicConfigProvider.tabs.position('bottom');

  $stateProvider
    .state('home', {
      url: "/",
      templateUrl: 'src/home/home.html',
      controller: 'HomeController'
    });

});
