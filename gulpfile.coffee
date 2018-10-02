gulp        = require 'gulp'
order       = require 'gulp-order'
autoprefixer = require 'gulp-autoprefixer'
concat      = require 'gulp-concat'
uglify      = require 'gulp-uglify'
stylus      = require 'gulp-stylus'
coffee      = require 'gulp-coffee'
jade        = require 'gulp-jade'
minify_html = require 'gulp-htmlmin'
minify_css  = require 'gulp-clean-css'
deploy      = require 'gulp-gh-pages'

development_path =
  images:     './development/images/**'
  coffee:     './development/coffee/**'
  stylus:     './development/stylus/**'
  jade:       './development/**.jade'
  build:      './build/**/*'
  copy:       ['./development/{pdf,svg,js}/**/*', './development/CNAME']

production_path =
  images: './build/images/'
  js:     './build/js/'
  css:    './build/css/'
  html:   './build/'
  copy:   './build/'


gulp.task('stylus', ()->
    return gulp.src(development_path.stylus)
    .pipe(stylus(
      set:['compress']
    ))
    .pipe(autoprefixer({
      browsers: ['last 2 versions'],
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
    .pipe(jade())
    .pipe(minify_html(
      empty: true
      conditionals: true
    ))
    .pipe gulp.dest(production_path.html)
)

gulp.task('build', ['copy', 'jade', 'stylus', 'coffee'], ()->


)

gulp.task('deploy',  ()->
  console.log 'deploying'
  return gulp.src(development_path.build)
    .pipe(deploy().on('error', ()->
      console.log 'error', arguments
      ))

)

gulp.task('watch', ()->
  gulp.watch development_path.jade,   ['jade']
  gulp.watch development_path.stylus, ['stylus']
  gulp.watch development_path.coffee, ['coffee']
)

gulp.task 'default', ['jade', 'stylus', 'coffee', 'watch']
