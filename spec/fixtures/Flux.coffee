define [
  'React'
], (React) ->
  {p} = React.DOM
  Basic = React.createClass
    getDefaultProps: ->
      greeting: 'Hello'
      recipient: 'World'
      emitEvent: ->
    componentWillReceiveProps: (newProps) ->
      propsToSend = JSON.parse JSON.stringify newProps
      delete propsToSend.emitEvent
      return if Object.keys(propsToSend).length is 0
      @props.emitEvent 'updated', propsToSend
    render: ->
      (p {}, ["#{@props.greeting}, #{@props.recipient}!"])
