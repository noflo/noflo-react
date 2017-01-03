noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai'
  path = require 'path'
  baseDir = path.resolve __dirname, '../'
else
  baseDir = 'noflo-react'

expect = chai.expect unless expect

requirejs ['cs!fixtures/Basic', 'React'], ->

  [Component, React] = arguments


  describe 'SetProps', ->

    c = null
    loader = null

    before ->
      loader = new noflo.ComponentLoader baseDir
    beforeEach (done) ->
      @timeout 4000
      loader.load 'react/Mount', (err, instance) ->
        return done err if err
        c = instance
        done()

    describe 'inPorts', ->

      it 'should contain "instance"', ->
        expect(c.inPorts.instance).to.be.an 'object'

      it 'should contain "props"', ->
        expect(c.inPorts.props).to.be.an 'object'

    describe 'data flow', ->

      mountPoint = null
      component = null
      instance = null
      instanceIn = null
      propsIn = null

      beforeEach ->
        instanceIn = noflo.internalSocket.createSocket()
        propsIn = noflo.internalSocket.createSocket()

        c.inPorts.instance.attach instanceIn
        c.inPorts.props.attach propsIn

        component = new Component
          test: false
        mountPoint = document.getElementById 'mount'
        instance = React.renderComponent component, mountPoint

      afterEach ->
        React.unmountComponentAtNode mountPoint

      describe 'with "props" first and "instance" sencond', ->

        beforeEach ->
          instanceIn.send instance
          instanceIn.disconnect()
          propsIn.send test: true
          propsIn.disconnect()

        it 'should set the props', ->
          expect(instance.props.test).to.be.true

      describe 'with "instance" first and "props" sencond', ->

        beforeEach ->
          propsIn.send test: true
          propsIn.disconnect()
          instanceIn.send instance
          instanceIn.disconnect()

        it 'should set the props', ->
          expect(instance.props.test).to.be.true

      describe 'with invalid data on "props"', ->

        beforeEach ->
          instanceIn.send instance
          instanceIn.disconnect()
          propsIn.send 'invalid data'
          propsIn.disconnect()

        it 'should do nothing', ->
          expect(instance.props.test).to.be.false

      describe 'on an unmounted component', ->

        beforeEach ->
          instanceIn.send instance
          instanceIn.disconnect()
          React.unmountComponentAtNode mountPoint

          propsIn.send test: true
          propsIn.disconnect()

        it 'should do nothing with the unmounted component', ->
          expect(instance.isMounted()).to.be.false
          expect(instance.props.test).to.be.false

        it 'should apply the props to next component being send', ->
          instance = React.renderComponent component, mountPoint
          expect(instance.isMounted()).to.be.true

          instanceIn.send instance
          instanceIn.disconnect()

          expect(instance.props.test).to.be.true
