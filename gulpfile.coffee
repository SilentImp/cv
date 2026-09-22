gulp        = require 'gulp'
order       = require 'gulp-order'
autoprefixer = require 'gulp-autoprefixer'
concat      = require 'gulp-concat'
uglify      = require 'gulp-uglify'
stylus      = require 'gulp-stylus'
coffee      = require 'gulp-coffee'
pug         = require 'gulp-pug'
minify_html = require 'gulp-htmlmin'
minify_css  = require 'gulp-clean-css'

development_path =
  images:     './development/images/**'
  coffee:     './development/coffee/**'
  stylus:     './development/stylus/**'
  jade:       './development/**.jade'
  build:      './docs/**/*'
  copy:       ['./development/{pdf,svg,js}/**/*', './development/CNAME']

production_path =
  images: './docs/images/'
  js:     './docs/js/'
  css:    './docs/css/'
  html:   './docs/'
  copy:   './docs/'


gulp.task('stylus', ()->
    return gulp.src(development_path.stylus)
    .pipe(stylus(
      set:['compress']
    ))
    .pipe(autoprefixer({
      overrideBrowserslist: ['last 2 versions'],
      cascade: false
    }))
    .pipe(order([
      'typography.styl'
      'reset.css'
    ]))
    .pipe(concat('styles.css'))
    .pipe(minify_css(
      keepSpecialComments: 0
      removeEmpty: true
    ))
    .pipe gulp.dest(production_path.css)
)


gulp.task('copy', ()->
  return gulp.src(development_path.copy).pipe(gulp.dest(production_path.copy))
)

gulp.task('coffee', ()->
  return gulp.src(development_path.coffee)
    .pipe(coffee(
      bare: true
    ))
    .pipe(uglify())
    .pipe gulp.dest(production_path.js)
)

gulp.task('jade', ()->
  return gulp.src(development_path.jade)
    .pipe(pug())
    .pipe(minify_html(
      empty: true
      conditionals: true
    ))
    .pipe gulp.dest(production_path.html)
)

gulp.task('build', gulp.parallel('copy', 'jade', 'stylus', 'coffee'))

gulp.task('watch', ()->
  gulp.watch development_path.jade,   gulp.series('jade')
  gulp.watch development_path.stylus, gulp.series('stylus')
  gulp.watch development_path.coffee, gulp.series('coffee')
)

gulp.task 'default', gulp.series(gulp.parallel('jade', 'stylus', 'coffee'), 'watch')
