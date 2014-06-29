noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  instance = null
  props = {}
  c = new noflo.Component
  c.description = 'Set properties of a React component'
  c.inPorts.add 'instance',
    datatype: 'object'
    description: 'React component instance'
    process: (event, payload) ->
      return unless event is 'data'
      instance = payload
      return unless Object.keys(props).length > 0
      instance.setProps props
      props = {}
  c.inPorts.add 'props',
    datatype: 'object'
    description: 'Properties to set'
    process: (event, payload) ->
      return unless event is 'data'
      unless instance
        return unless typeof props is 'object'
        props = payload
        return
      instance.setProps payload
  c
