'use strict'

noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = "Configures a React component with a given set of props,
    suitable for mounting."

  # inPorts
  c.inPorts.add 'component',
    datatype: 'function'
    description: 'The component class to be configured.'
    required: true

  c.inPorts.add 'props',
    datatype: 'object'
    description: 'Props used to configure the component class.'
    required: true

  # outPorts
  c.outPorts.add 'class',
    datatype: 'object'
    description: 'The configured component class.'

  noflo.helpers.WirePattern c,
    in: ['component', 'props']
    out: ['class']
    forwardGroups: true
    async: false
  ,
    (data, groups, out) ->
      component = data.component data.props

      out.send component
