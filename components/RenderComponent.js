var noflo = require('noflo');
var React = require('react');
var ReactDOM = require('react-dom');

exports.getComponent = function () {
  var c = new noflo.Component();
  c.description = 'Render a React component to a given mountpoint and allow setting props and receiving events';
  c.inPorts.add('component', {
    datatype: 'function'
  });
  c.inPorts.add('container', {
    datatype: 'object'
  });
  c.inPorts.add('props', {
    datatype: 'object'
  });
  c.outPorts.add('event', {
    datatype: 'object'
  });
  c.outPorts.add('error', {
    datatype: 'object'
  });
  c.forwardBrackets = {};
  c.autoOrdering = false;
  c.mounted = {};
  c.clearElement = function (scope) {
    if (!c.mounted[scope]) {
      return;
    }
    ReactDOM.unmountComponentAtNode(c.mounted[scope].container);
    c.mounted[scope].ctx.deactivate();
    delete c.mounted[scope];
  };
  c.tearDown = function (callback) {
    Object.keys(c.mounted).forEach(function (scope) {
      c.clearElement(scope);
    });
    callback();
  };
  c.process(function (input, output, context) {
    if (input.hasData('component', 'container')) {
      var component = input.getData('component');
      var container = input.getData('container');
      c.clearElement(input.scope);

      var props = {};
      if (input.hasData('props')) {
        // We already have first set of props
        props = input.getData('props');
      }

      var emitEvent = function (events, payload, metadata) {
        if (typeof events === 'string') {
          events = [events];
        }
        events.forEach(function (eventName) {
          output.send({
            event: new noflo.IP('openBracket', eventName)
          });
        });
        output.send({
          event: new noflo.IP('data', payload)
        });
        events.reverse();
        events.forEach(function (eventName) {
          output.send({
            event: new noflo.IP('closeBracket', eventName)
          });
        });
      };
      props.emitEvent = emitEvent;

      ReactDOM.render(
        React.createElement(component, props, null),
        container
      );
      c.mounted[input.scope] = {
        ctx: context,
        component: component,
        container: container,
        emitEvent: emitEvent
      };
      return;
    }
    if (!c.mounted[input.scope]) {
      // Don't receive props before we've mounted an instance
      return;
    }
    if (!input.hasData('props')) {
      return;
    }
    var props = input.getData('props');
    props.emitEvent = c.mounted[input.scope].emitEvent;
    ReactDOM.render(
      React.createElement(c.mounted[input.scope].component, props, null),
      c.mounted[input.scope].container
    );
    output.done();
  });
  return c;
}
