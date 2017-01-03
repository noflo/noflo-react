noflo = require 'noflo'

describe 'Render subgraph', ->
  c = null
  module = null
  container = null
  props = null
  event = null
  error = null
  beforeEach (done) ->
    @timeout 10000
    loader = new noflo.ComponentLoader '/noflo-react'
    loader.load 'react/Render', (err, instance) ->
      return done err if err
      c = instance
      c.once 'ready', ->
        c.network.on 'process-error', (err) ->
          setTimeout ->
            throw err.error or err
          , 1
        module = noflo.internalSocket.createSocket()
        container = noflo.internalSocket.createSocket()
        props = noflo.internalSocket.createSocket()
        event = noflo.internalSocket.createSocket()
        error = noflo.internalSocket.createSocket()
        c.inPorts.module.attach module
        c.inPorts.container.attach container
        c.inPorts.props.attach props
        c.outPorts.event.attach event
        c.outPorts.error.attach error
        c.start()
        done()

  describe 'rendering a React component', ->
    it 'should be able to transmit events back to NoFlo', (done) ->
      expected = [
        greeting: 'Terve'
        recipient: 'Maailma'
      ,
        greeting: 'Hallo'
        recipient: 'Welt'
      ,
        greeting: 'Hello'
        recipient: 'World'
      ,
        greeting: 'Здраво'
        recipient: 'свете'
      ]
      expectedProps = null
      error.on 'data', (data) ->
        done data
      event.on 'data', (data) ->
        chai.expect(data).to.eql expectedProps
        setTimeout ->
          chai.expect(document.querySelector('#render p span').innerText).to.equal "#{expectedProps.greeting}, #{expectedProps.recipient}!"
          return done() unless expected.length
          expectedProps = expected.shift()
          props.send JSON.parse JSON.stringify expectedProps
        , 1
      module.send 'cs!fixtures/Flux'
      container.send document.getElementById 'render'
      expectedProps = expected.shift()
      props.send JSON.parse JSON.stringify expectedProps
