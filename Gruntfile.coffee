module.exports = ->
  # Project configuration
  @initConfig
    pkg: @file.readJSON 'package.json'

    # Browser build of NoFlo
    noflo_browser:
      build:
        files:
          'browser/noflo-react.js': ['package.json']

    # BDD tests on browser
    mocha_phantomjs:
      options:
        output: 'spec/result.xml'
        reporter: 'spec'
        failWithOutput: true
      all: ['spec/runner.html']

  # Grunt plugins used for building
  @loadNpmTasks 'grunt-noflo-browser'

  # Grunt plugins used for testing
  @loadNpmTasks 'grunt-mocha-phantomjs'

  # Our local tasks
  @registerTask 'build', 'Build NoFlo for the chosen target platform', (target = 'all') =>
    @task.run 'noflo_browser'

  @registerTask 'test', 'Build NoFlo and run automated tests', (target = 'all') =>
    @task.run 'build'
    @task.run 'mocha_phantomjs'

  @registerTask 'default', ['test']
