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

  mount = (data, groups, out) ->
    load.getReact (err, React) ->
      if err
        c.outPorts.error.send err
        c.outPorts.error.disconnect()
        return

      try
        instance = React.renderComponent data.component(), data.container
      catch e
        c.outPorts.error.send e
        c.outPorts.error.disconnect()
        return
      out.send instance

  noflo.helpers.GroupComponent c, mount, ['component', 'container'], 'instance'

  c
