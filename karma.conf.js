module.exports = function(config) {
  config.set({

    // base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: '',


    // frameworks to use
    // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['jasmine'],


    // list of files / patterns to load in the browser
    files: [
      'www/lib/ionic/js/ionic.bundle.js',
      'www/lib/ngCordova/dist/ng-cordova.js',
      'www/lib/ngCordova/dist/ng-cordova-mocks.js',
      'www/lib/angular-ui-router/release/angular-ui-router.min.js',
      'www/lib/angular-route/angular-route.js',
      'www/lib/angular-sanitize/angular-sanitize.min.js',
      'www/lib/angular-animate/angular-animate.min.js',
      'www/lib/angular-mocks/angular-mocks.js',
      'www/lib/ng-cordova-oauth/dist/ng-cordova-oauth.js',
      'www/lib/angular-translate/angular-translate.js',
      'www/lib/angular-translate-loader-static-files/angular-translate-loader-static-files.js',
      'www/lib/angular-jwt/dist/angular-jwt.js',
      'www/lib/openfb.js',
      'www/lib/facebook.js',
      'www/lib/facebook.js',
      'www/src/**/*.js'
    ],


    // list of files to exclude
    exclude: [
    ],


    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
      'www/src/**/!(*.spec).js': ['coverage']
    },

    coverageReporter: {
      type : 'html',
      subdir: '.',
      reportName: 'report',
      dir : 'tests/coverage'
    },

    reporters: ['progress', 'html', 'coverage'],


    // the default configuration 
    htmlReporter: {
      outputDir: 'tests', // where to put the reports  
      templatePath: null, // set if you moved jasmine_template.html 
      focusOnFailures: true, // reports show failures on start 
      namedFiles: false, // name files instead of creating sub-directories 
      pageTitle: null, // page title for reports; browser info by default 
      urlFriendlyName: false, // simply replaces spaces with _ for files/dirs 
      reportName: 'report', // report summary filename; browser info by default 
      // dir: 'tests/report',
      // experimental 
      preserveDescribeNesting: false, // folded suites stay folded  
      foldAll: false, // reports start folded (only with preserveDescribeNesting) 
    },

    // web server port
    port: 9876,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,


    // start these browsers
    // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['Chrome'],


    // Continuous Integration mode
    // if true, Karma captures browsers, runs the tests and exits
    singleRun: false,

    // Concurrency level
    // how many browser should be started simultaneous
    concurrency: Infinity

  })
}
