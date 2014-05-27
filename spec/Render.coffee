noflo = require 'noflo'

describe 'Render subgraph', ->
  c = null
  module = null
  container = null
  props = null
  event = null
  beforeEach (done) ->
    @timeout 10000
    loader = new noflo.ComponentLoader '/noflo-react'
    loader.load 'react/Render', (instance) ->
      c = instance
      c.once 'ready', ->
        module = noflo.internalSocket.createSocket()
        container = noflo.internalSocket.createSocket()
        props = noflo.internalSocket.createSocket()
        event = noflo.internalSocket.createSocket()
        c.inPorts.module.attach module
        c.inPorts.container.attach container
        c.inPorts.props.attach props
        c.outPorts.event.attach event
        done()

  describe 'rendering a React component', ->
    it 'should be able to transmit events back to NoFlo', (done) ->
      expected = [
        greeting: 'Terve'
        recipient: 'Maailma'
      ,
        greeting: 'Hallo'
        recipient: 'Welt'
      ]
      event.on 'data', (data) ->
        exp = expected.shift()
        chai.expect(data).to.eql exp
        setTimeout ->
          chai.expect(document.querySelector('#render p span').innerText).to.equal "#{exp.greeting}, #{exp.recipient}!"
          done() if expected.length is 0
        , 1
      module.send 'cs!fixtures/Flux'
      container.send document.getElementById 'render'
      props.send
        greeting: 'Terve'
        recipient: 'Maailma'
      setTimeout ->
        props.send
          greeting: 'Hallo'
          recipient: 'Welt'
      , 100
