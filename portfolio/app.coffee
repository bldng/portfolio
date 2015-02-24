axis            = require 'axis'
rupture         = require 'rupture'
autoprefixer    = require 'autoprefixer-stylus'
# js_pipeline     = require 'js-pipeline'
css_pipeline    = require 'css-pipeline'
dynamic_content = require 'dynamic-content'
ClientTemplates = require 'client-templates'
browserify      = require 'roots-browserify'
records         = require 'roots-records'

module.exports =

  open_browser: false

  ignores: ['readme.md', '**/layout.*', '**/_*', '.gitignore', 'ship.*conf']

  server: 
    clean_urls: true

  extensions: [
    # js_pipeline(files: 'assets/js/*.coffee'),
    css_pipeline(files: 'assets/css/*.styl'),
    dynamic_content(write: 'js/content.json'),
    browserify(files: "assets/js/main.coffee", out: 'js/build.js', transforms: 'coffeeify', minify: false),
    records( projects: {file: 'public/js/content.json', path: 'projects/items'}),
    ClientTemplates(
      base: "views/templates/"
      pattern: "**/*.jade"
      out: "js/templates.js"
      )
  ]

  stylus:
    use: [axis(), rupture(), autoprefixer()]
    sourcemap: true

  'coffee-script':
    sourcemap: true

  jade:
    pretty: true
