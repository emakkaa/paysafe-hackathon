var gulp = require('gulp'); 
var jshint = require('gulp-jshint');
var clean = require('gulp-clean');
var sass = require('gulp-sass');
var minifyCss = require('gulp-minify-css');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var htmlhint = require("gulp-htmlhint");
var htmlhintStylish = require("htmlhint-stylish");
var lintspaces = require("gulp-lintspaces");
var Server = require('karma').Server;

gulp.task('lint', function() {
  return gulp.src('./www/src/**/*.js')
    .pipe(jshint())
    .pipe(jshint.reporter('default'));
});

gulp.task('clean', function() {
  return gulp.src('./www/build', { read: false })
    .pipe(clean());
});

gulp.task('sass', function() {
  return gulp.src('./www/src/**/*.scss')
    .pipe(lintspaces({
      trailingspaces: true,
      indentation: 'spaces',
      spaces: 2
    }))
    .pipe(lintspaces.reporter())
	.pipe(sass({
            includePaths: ['./www/src/core/style']
     }))
    .pipe(concat('all.min.css'))
    .pipe(sass())
    .pipe(minifyCss({compatibility: 'ie8'}))
    .pipe(gulp.dest('./www/build/'));
});

gulp.task('scripts', function() {
  return gulp.src(['./www/src/**/*.js', '!./www/src/**/*.spec.js'])
    .pipe(lintspaces({
      trailingspaces: true,
      indentation: 'spaces',
      spaces: 2
    }))
    .pipe(lintspaces.reporter())
	
    .pipe(concat('all.min.js'))
    .pipe(uglify({mangle: false}))
    .pipe(gulp.dest('./www/build/'));
});

gulp.task('validate_html', function() {
  gulp.src('./www/src/**/*.html')
    .pipe(lintspaces({
      trailingspaces: true,
      indentation: 'spaces',
      spaces: 2
    }))
    .pipe(lintspaces.reporter())
    .pipe(htmlhint('.htmlhintrc'))
    .pipe(htmlhint.reporter("htmlhint-stylish"))
});

gulp.task('watch', function() {
  gulp.watch('./www/src/**/*.js', ['clean', 'lint', 'sass', 'scripts', 'validate_html']);
  gulp.watch('./www/src/**/*.scss', ['clean', 'lint', 'sass', 'scripts', 'validate_html']);
  gulp.watch('./www/src/**/*.html', ['clean', 'lint', 'sass', 'scripts', 'validate_html']);
});

gulp.task('build', [ 'watch' ]);

gulp.task('default', ['build']);