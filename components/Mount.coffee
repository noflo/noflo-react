noflo = require 'noflo'
load = require '../lib/load'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Render a React component in the given mountpoint'

  c.inPorts.add 'component',
    datatype: 'function'
    description: 'The React component to mount'
  c.inPorts.add 'container',
    datatype: 'object'
    description: 'DOM element to use for mounting the component'

  c.outPorts.add 'instance',
    datatype: 'object'
  c.outPorts.add 'error',
    datatype: 'object'
    required: false

  mount = (data, groups, out, callback) ->
    load.getReact (err, React) ->
      return callback err if err

      try
        instance = React.renderComponent data.component(), data.container
      catch e
        return callback e
      out.send instance
      callback()

  noflo.helpers.GroupedInput c,
    in: ['component', 'container']
    out: 'instance'
    async: true
  , mount

  c
