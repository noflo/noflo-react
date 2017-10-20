noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Listen for events emitted by React components using the emitEvent property'
  c.inPorts.add 'instance',
    datatype: 'object'
    description: 'React component instance'
  c.outPorts.add 'event',
    datatype: 'object'
  c.subscribed = {}
  c.tearDown = (callback) ->
    for scope, ctx of c.subscribed
      ctx.deactivate()
    c.subscribed = {}
    do callback
  c.process (input, output, context) ->
    return unless input.hasData 'instance'
    instance = input.getData 'instance'
    instance.setProps
      emitEvent: (events, payload, metadata) ->
        events = [events] if typeof events is 'string'
        for event in events
          output.send
            out: new noflo.IP 'openBracket', event
        out.send
          out: payload
        closes = events.slice 0
        closes.reverse()
        for event in closes
          output.send
            out: new noflo.IP 'closeBracket', event
    c.subscribed[input.scope] = context
