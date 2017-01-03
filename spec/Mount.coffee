noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai'
  path = require 'path'
  baseDir = path.resolve __dirname, '../'
else
  baseDir = 'noflo-react'

describe 'Mount component', ->
  c = null
  component = null
  container = null
  instance = null
  before (done) ->
    @timeout 4000
    loader = new noflo.ComponentLoader baseDir
    loader.load 'react/Mount', (err, instance) ->
      return done err if err
      c = instance
      component = noflo.internalSocket.createSocket()
      container = noflo.internalSocket.createSocket()
      c.inPorts.component.attach component
      c.inPorts.container.attach container
      done()
  beforeEach ->
    instance = noflo.internalSocket.createSocket()
    c.outPorts.instance.attach instance
  afterEach ->
    c.outPorts.instance.detach instance

  describe 'when instantiated', ->
    it 'should have an input ports', ->
      chai.expect(c.inPorts.component).to.be.an 'object'
      chai.expect(c.inPorts.container).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(c.outPorts.instance).to.be.an 'object'
  describe 'mounting a component', ->
    it 'should be able to create an instance', (done) ->
      @timeout 4000
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
        component.send Basic()
        component.disconnect()
