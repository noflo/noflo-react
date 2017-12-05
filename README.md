# noflo-react [![Build Status](https://secure.travis-ci.org/noflo/noflo-react.png?branch=master)](http://travis-ci.org/noflo/noflo-react) [![Build status](https://ci.appveyor.com/api/projects/status/6hb0wbf2j7jcri9b)](https://ci.appveyor.com/project/bergie/noflo-react)

Facebook React components for NoFlo

## Changes

* 0.4.0 (December 05 2017)
  - Updated from React 0.14 to React 16.x
  - Removed `ListenEvents`, `Mount`, `SetProps`, and `Unmount` components since they're incompatible with how modern React works
  - Added `RenderComponent` component that works like `Render` but accepts a React component interface instead of using AMD
  - Ported from CoffeeScript to JavaScript
