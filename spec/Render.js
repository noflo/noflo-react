var noflo = require('noflo');

describe('Render subgraph', function() {
  var c = null;
  var module = null;
  var container = null;
  var props = null;
  var event = null;
  var error = null;
  beforeEach(function(done) {
    this.timeout(10000);
    var loader = new noflo.ComponentLoader('/noflo-react');
    loader.load('react/Render', function(err, instance) {
      if (err) { return done(err); }
      c = instance;
      c.once('ready', function () {
        module = noflo.internalSocket.createSocket();
        container = noflo.internalSocket.createSocket();
        props = noflo.internalSocket.createSocket();
        event = noflo.internalSocket.createSocket();
        error = noflo.internalSocket.createSocket();
        c.inPorts.module.attach(module);
        c.inPorts.container.attach(container);
        c.inPorts.props.attach(props);
        c.outPorts.event.attach(event);
        c.outPorts.error.attach(error);
        c.start(done);
      });
    });
  });

  describe('rendering a React component', function () {
    after(function (done) {
      c.tearDown(done);
    });
    it('should be able to transmit events back to NoFlo', function(done) {
      var expected = [{
        greeting: 'Terve',
        recipient: 'Maailma'
      }, {
        greeting: 'Hallo',
        recipient: 'Welt'
      }, {
        greeting: 'Hello',
        recipient: 'World'
      }, {
        greeting: 'Здраво',
        recipient: 'свете'
      }
      ];
      var expectedProps = null;
      error.on('data', function (data) { done(data); });
      event.on('data', function(data) {
        chai.expect(data).to.eql(expectedProps);
        setTimeout(function() {
          var mountpoint = document.querySelector('#render p');
          chai.expect(mountpoint.innerText).to.equal(expectedProps.greeting + ', ' + expectedProps.recipient + '!');
          if (!expected.length) { return done(); }
          expectedProps = expected.shift();
          props.send(JSON.parse(JSON.stringify(expectedProps)));
        }, 1);
      });
      module.send('fixtures/Flux');
      container.send(document.getElementById('render'));
      expectedProps = expected.shift();
      props.send(JSON.parse(JSON.stringify(expectedProps)));
    });
  });
});
