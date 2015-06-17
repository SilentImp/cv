gulp        = require 'gulp'
order       = require 'gulp-order'
imagemin    = require 'gulp-imagemin'
prefix      = require 'gulp-autoprefixer'
concat      = require 'gulp-concat'
uglify      = require 'gulp-uglify'
stylus      = require 'gulp-stylus'
coffee      = require 'gulp-coffee'
jade        = require 'gulp-jade'
minify_html = require 'gulp-minify-html'
minify_css  = require 'gulp-minify-css'
deploy      = require 'gulp-gh-pages'

development_path =
  images:     './development/images/**'
  coffee:     './development/coffee/**'
  stylus:     './development/stylus/**'
  jade:       './development/**.jade'
  production: './production/**'

production_path =
  images: './production/images/'
  js:     './production/js/'
  css:    './production/css/'
  html:   './production/'


gulp.task('stylus', ()->
    gulp.src(development_path.stylus)
    .pipe(stylus(
      set:['compress']
    ))
    .pipe(prefix())
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

gulp.task('coffee', ()->
  gulp.src(development_path.coffee)
    .pipe(coffee(
      bare: true
    ))
    .pipe(uglify())
    .pipe gulp.dest(production_path.js)
)

gulp.task('jade', ()->
  gulp.src(development_path.jade)
    .pipe(jade())
    .pipe(minify_html(
      empty: true
      conditionals: true
    ))
    .pipe gulp.dest(production_path.html)
)

gulp.task('images', ()->
  gulp.src(development_path.images)
    .pipe(imagemin(
      optimizationLevel: 3
    ))
    .pipe gulp.dest(production_path.images)
)

gulp.task('build', ['jade', 'stylus', 'coffee'], ()->
    
  
)

gulp.task('deploy', ()->
  console.log 'deploying'
  return gulp.src(development_path.production)
    .pipe(deploy({
      cacheDir:   'gh-cache',
      remoteUrl:  'git@github.com:SilentImp/cv.git'
    }).on('error', ()->
      console.log('error', arguments)
    ))
)

gulp.task('watch', ()->
  gulp.watch development_path.jade,   ['jade']
  gulp.watch development_path.stylus, ['stylus']
  gulp.watch development_path.coffee, ['coffee']
  # gulp.watch development_path.images, ['images']
)

gulp.task 'default', ['jade', 'stylus', 'coffee', 'watch']
