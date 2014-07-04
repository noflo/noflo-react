noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  # Private variables.
  instance = null
  props = {}

  # Component.
  c = new noflo.Component
  c.description = 'Set properties of a React component'

  # Declare inPorts.
  c.inPorts.add 'instance',
    datatype: 'object'
    description: 'React component instance'
    process: (event, payload) ->
      return unless event is 'data'
      instance = payload

      return unless Object.keys(props).length > 0

      if instance.isMounted()
        instance.setProps props
        props = {}

  c.inPorts.add 'props',
    datatype: 'object'
    description: 'Properties to set'
    process: (event, payload) ->
      return unless event is 'data' and payload instanceof Object

      unless instance and instance.isMounted()
        props = payload
        return

      instance.setProps payload
  c
