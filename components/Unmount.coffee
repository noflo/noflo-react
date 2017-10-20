noflo = require 'noflo'
load = require '../lib/load'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Unmount a React component from a given mountpoint'
  c.inPorts.add 'container',
    datatype: 'object'
    description: 'DOM element where a React component is mounted'
  c.outPorts.add 'unmounted',
    datatype: 'boolean'
    required: false
  c.outPorts.add 'error',
    datatype: 'object'
    required: false
  c.process (input, output) ->
    return unless input.hasData 'container'
    container = input.getData 'container'
    load.getReact (err, React) ->
      if err
        output.done err
        return
      output.sendDone
        unmontainer: React.unmountComponentAtNode container
    return
