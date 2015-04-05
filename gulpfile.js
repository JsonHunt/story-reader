var gulp = require('gulp');

gulp.task('autoprefixer', function () {
		var postcss      = require('gulp-postcss');
		var sourcemaps   = require('gulp-sourcemaps');
		var autoprefixer = require('autoprefixer-core');

		return gulp.src('./mobile/www/bundle.css')
				.pipe(sourcemaps.init())
				.pipe(postcss([ autoprefixer({ browsers: ['last 80 versions'] }) ]))
				.pipe(sourcemaps.write('.'))
				.pipe(gulp.dest('./mobile/www'));
});
