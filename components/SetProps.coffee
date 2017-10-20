noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Set properties of a React component'

  # Declare inPorts.
  c.inPorts.add 'instance',
    datatype: 'object'
    description: 'React component instance'
    control: true
  c.inPorts.add 'props',
    datatype: 'object'
    description: 'Properties to set'
  c.process (input, output) ->
    return unless input.hasData 'instance', 'props'
    [instance, props] = input.getData 'instance', 'props'
    instance.setProps props
    output.done()
    return
