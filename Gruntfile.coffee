module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  grunt.loadNpmTasks 'grunt-mocha-cli'

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
      dist: 'test/test.coffee'
      options:
        compilers:[
          'coffee:coffee-script'
        ]

    copy:
      dist:
        dest: 'dist/backbone.smartclasses.js'
        src: 'lib/backbone.smartclasses.js'

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
    'mochacli'
    'copy'
    'uglify'
  ]

  grunt.registerTask 'test', [
    'jshint:lib'
    'mochacli'
  ]
