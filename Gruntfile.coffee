module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  grunt.loadNpmTasks 'grunt-mocha-cli'
  grunt.loadNpmTasks 'grunt-umd'

  grunt.initConfig
    pkg:
      grunt.file.readJSON 'package.json'

    clean:
      dist: [
        'dist'
      ]

    jshint:
      options:
        jshintrc: '.jshintrc'
      lib:
        files:
          src: 'lib'

    mochacli:
      travis:
        dist: 'test/test.coffee'
        options:
          compilers:[
            'coffee:coffee-script'
          ]
      cli:
        dist: 'test/test.coffee'
        options:
          compilers:[
            'coffee:coffee-script'
          ]
          reporter: 'spec'

    umd:
      dist:
        src: 'lib/backbone.smartclasses.js'
        dest: 'dist/backbone.smartclasses.js'
        objectToExport: 'smartclasses'
        globalAlias: 'smartclasses'
        deps:
          default: ['Backbone', '_']
          amd: ['backbone', 'lodash']
          cjs: ['backbone', 'lodash']

    uglify:
      dist:
        options:
          sourceMap: 'dist/backbone.smartclasses.map'
          mangle: false
        files:
          'dist/backbone.smartclasses.min.js': 'lib/backbone.smartclasses.js'


  grunt.registerTask 'default', [
    'clean:dist'
    'jshint:lib'
    'umd:dist'
    'mochacli'
    'uglify'
  ]

  grunt.registerTask 'test', [
    'clean:dist'
    'jshint:lib'
    'umd:dist'
    'mochacli:cli'
  ]
  grunt.registerTask 'travis', [
    'clean:dist'
    'jshint:lib'
    'umd:dist'
    'mochacli:travis'
  ]
