noflo = require 'noflo'

# @runtime noflo-browser

subscribe = (instance, out) ->
  instance.setProps
    emitEvent: (events, payload, metadata) ->
      events = [events] if typeof events is 'string'
      out.beginGroup event for event in events
      out.send payload
      out.endGroup event for event in events
      out.disconnect()

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Listen for events emitted by React components using the emitEvent property'
  c.inPorts.add 'instance',
    datatype: 'object'
    description: 'React component instance'
    process: (event, payload) ->
      return unless event is 'data'
      subscribe payload, c.outPorts.event
  c.outPorts.add 'event',
    datatype: 'object'

  c
