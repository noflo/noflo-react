define [
  'React'
], (React) ->
  {p} = React.DOM
  Basic = React.createClass
    render: ->
      (p {}, ['Hello, World!'])
