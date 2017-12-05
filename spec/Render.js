const noflo = require('noflo');

describe('Render subgraph', function() {
  let c = null;
  let module = null;
  let container = null;
  let props = null;
  let event = null;
  let error = null;
  beforeEach(function(done) {
    this.timeout(10000);
    const loader = new noflo.ComponentLoader('/noflo-react');
    return loader.load('react/Render', function(err, instance) {
      if (err) { return done(err); }
      c = instance;
      return c.once('ready', function() {
        c.network.on('process-error', err =>
          setTimeout(function() {
            throw err.error || err;
          }
          , 1)
        );
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
        return c.start(done);
      });
    });
  });

  return describe('rendering a React component', () =>
    it('should be able to transmit events back to NoFlo', function(done) {
      const expected = [{
        greeting: 'Terve',
        recipient: 'Maailma'
      }
      , {
        greeting: 'Hallo',
        recipient: 'Welt'
      }
      , {
        greeting: 'Hello',
        recipient: 'World'
      }
      , {
        greeting: 'Здраво',
        recipient: 'свете'
      }
      ];
      let expectedProps = null;
      error.on('data', data => done(data));
      event.on('data', function(data) {
        chai.expect(data).to.eql(expectedProps);
        return setTimeout(function() {
          chai.expect(document.querySelector('#render p span').innerText).to.equal(`${expectedProps.greeting}, ${expectedProps.recipient}!`);
          if (!expected.length) { return done(); }
          expectedProps = expected.shift();
          return props.send(JSON.parse(JSON.stringify(expectedProps)));
        }
        , 1);
      });
      module.send('cs!fixtures/Flux');
      container.send(document.getElementById('render'));
      expectedProps = expected.shift();
      return props.send(JSON.parse(JSON.stringify(expectedProps)));
    })
  );
});
