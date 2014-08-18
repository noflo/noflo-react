'use strict'

unless noflo.isBrowser()
  chai = require 'chai' unless chai
  ConfigureComponent = require '../components/ConfigureComponent.coffee'
else
  ConfigureComponent = require 'noflo-react/components/ConfigureComponent.js'


describe 'ConfigureComponent', ->

  c = null

  beforeEach ->
    c = ConfigureComponent.getComponent()

  describe 'inPorts', ->

    it 'should include "component"', ->
      expect(c.inPorts.component).to.be.an 'object'

    it 'should include "props"', ->
      expect(c.inPorts.props).to.be.an 'object'

  describe 'outPorts', ->

    it 'should include "class"', ->
      expect(c.outPorts.class).to.be.an 'object'

  describe 'data flow', ->

    componentIn = null
    propsIn = null
    classOut = null

    beforeEach ->
      componentIn = noflo.internalSocket.createSocket()
      propsIn = noflo.internalSocket.createSocket()
      classOut = noflo.internalSocket.createSocket()

      c.inPorts.component.attach componentIn
      c.inPorts.props.attach propsIn
      c.outPorts.class.attach classOut

    it 'should create a configured react component', (done) ->
      classOut.once 'data', (data) ->
        expect(data.props).to.deep.equal
          greeting: 'Hello'
          recipient: 'Test'
        done()

      requirejs ['cs!fixtures/Flux'], (Flux) ->
        componentIn.send Flux
        componentIn.disconnect()

        propsIn.send
          greeting: 'Hello'
          recipient: 'Test'
        propsIn.disconnect()

    it 'should require the component port', ->
      called = false
      classOut.once (data) ->
        called = true

      propsIn.send
        greeting: 'Hello'
        recipient: 'Test'
      propsIn.disconnect()

      expect(called).to.be.false

    it 'should require the props port', ->
      called = false
      classOut.once (data) ->
        called = true

      requirejs ['cs!fixtures/Flux'], (Flux) ->
        componentIn.send Flux
        componentIn.disconnect()

      expect(called).to.be.false

    it 'should forward all groups', (done) ->
      classOut.once 'begingroup', (group) ->
        expect(group).to.equal 'test-group'
        done()

      requirejs ['cs!fixtures/Flux'], (Flux) ->
        componentIn.beginGroup 'test-group'
        componentIn.send Flux
        componentIn.endGroup
        componentIn.disconnect()

        propsIn.send
          greeting: 'Hello'
          recipient: 'Test'
        propsIn.disconnect()
