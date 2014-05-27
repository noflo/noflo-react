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

  noflo.helpers.MapComponent c, (data, groups, out) ->
    load.getReact (err, React) ->
      if err
        c.outPorts.error.send err
        c.outPorts.error.disconnect()
        return
      out.send React.unmountComponentAtNode data
  ,
    inPort: 'container'
    outPort: 'unmounted'

  c
