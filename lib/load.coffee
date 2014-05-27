React = null
exports.getReact = (callback) ->
  return callback null, React if React
  if window.React
    React = window.React
    return callback null, React
  if typeof window.requirejs is 'function'
    window.requirejs ['React'], (r) ->
      React = r
      callback null, r
    , (err) ->
      callback err
    return
  try
    React = require 'react'
  catch err
    callback err
    return
  callback null, React
