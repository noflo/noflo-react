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

  c.process (input, output) ->
    return unless input.hasData 'component', 'container'
    [component, container] = input.getData 'component', 'container'
    load.getReact (err, React) ->
      if err
        output.done err
        return

      try
        instance = React.renderComponent component(), container
      catch e
        output.done e
        return
      output.sendDone
        instance: instance
    return
