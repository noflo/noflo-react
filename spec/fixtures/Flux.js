define(['react'], function (React) {
  return function (props) {
    var greeting = props.greeting || 'Hello';
    var recipient = props.recipient || 'World';
    var emitEvent = props.emitEvent || function () {};
    var content = React.createElement('p', null, greeting + ', ' + recipient + '!');
    setTimeout(function () {
      emitEvent('updated', {
        greeting: greeting,
        recipient: recipient
      });
    }, 1);
    return content;
  };
});
