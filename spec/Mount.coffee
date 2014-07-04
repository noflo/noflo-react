noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  Mount = require '../components/Mount.coffee'
else
  Mount = require 'noflo-react/components/Mount.js'

describe 'Mount component', ->
  c = null
  component = null
  container = null
  instance = null
  beforeEach ->
    c = Mount.getComponent()
    component = noflo.internalSocket.createSocket()
    container = noflo.internalSocket.createSocket()
    instance = noflo.internalSocket.createSocket()
    c.inPorts.component.attach component
    c.inPorts.container.attach container
    c.outPorts.instance.attach instance

  describe 'when instantiated', ->
    it 'should have an input ports', ->
      chai.expect(c.inPorts.component).to.be.an 'object'
      chai.expect(c.inPorts.container).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(c.outPorts.instance).to.be.an 'object'
  describe 'mounting a component', ->
    it 'should be able to create an instance', (done) ->
      receivedData = false
      instance.on 'data', (data) ->
        chai.expect(data).to.be.an 'object'
        receivedData = true
      instance.on 'disconnect', ->
        chai.expect(document.querySelectorAll('#mount p').length).to.equal 1
        chai.expect(receivedData).to.be.true
        done()
      container.send document.getElementById 'mount'
      container.disconnect()
      requirejs ['cs!fixtures/Basic'], (Basic) ->
        component.send Basic
        component.disconnect()
