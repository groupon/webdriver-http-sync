# webdriver-http-sync

Sync implementation of the
[WebDriver protocol](https://code.google.com/p/selenium/wiki/JsonWireProtocol)
in Node.js.

Keep up to date with changes
by checking the
[releases](https://github.com/groupon-testium/webdriver-http-sync/releases).

Tested on node.js 0.10.* and io.js.

## Install

On Ubuntu, you need to make sure you have libcurl installed.
`sudo apt-get install libcurl4-openssl-dev`

```bash
npm install webdriver-http-sync
```

## WebDriver API

### WebDriver

Invocation:

```javascript
var driver = new WebDriver(serverUrl, desiredCapabilities, httpOptions);
```

Simple Example:

```javascript
var WebDriver = require('webdriver-http-sync');
var desiredCapabilities = {browserName: 'firefox'};

// Assuming selenium (packaged separately) has already been started:
// java -jar selenium-server-standalone-2.42.2.jar

var driver = new WebDriver('http://127.0.0.1:4444/wd/hub', desiredCapabilities);
driver.navigateTo('http://www.google.com');
```

### Sauce Labs

You can use this library with SauceLabs or any another browser service with authorization. Just add your credentials into URL:

```javascript
var WebDriver = require('webdriver-http-sync');
var desiredCapabilities = {browserName: 'firefox'};

var driver = new WebDriver('http://SAUCE_USERNAME:SAUCE_API_KEY@ondemand.saucelabs.com:4444/wd/hub', desiredCapabilities);
driver.navigateTo('http://www.google.com');
```

Method | Description
:----- | :----------
`driver.navigateTo(url)` | Navigates the browser to the specificed relative or absolute url. If relative, the root is assumed to be `http://127.0.0.1:#{applicationPort}`, where `applicationPort` is passed in to the options for `testium.runTests`.
`driver.refresh()` | Refreshes the browser.
`driver.getElement(cssSelector)` | Finds an element on the page using the `cssSelector` and returns an Element.
`driver.getElements(cssSelector)` | Finds all elements on the page using the `cssSelector` and returns an array of Elements.
`driver.setTimeouts(type, milliseconds)` | Sets a timeout for a certain type of operation. Valid types are: "script" for script timeouts, "implicit" for modifying the implicit wait timeout and "page load" for setting a page load timeout.
`driver.setElementTimeout(milliseconds)` | Sets a timeout for WebDriver to find elements with `getElement` and `getElements`.
`driver.setScriptTimeout(milliseconds)` | Sets a timeout for WebDriver to execute async scripts with `evaluateAsync`.
`driver.getUrl()` | Returns the current url of the page.
`driver.getPageTitle()` | Returns the current page title.
`driver.getPageSource()` | Returns the current page's html source.
`driver.getScreenshot()` | Returns screenshot as a base64 encoded PNG.
`driver.evaluate(javascriptString)` | Executes the given javascript. It must contain a return statement in order to get a value back.
`driver.evaluateAsync(javascriptString)` | Executes the given asynchronous javascript. The executed script must signal that is done by invoking the provided callback, which is always provided as the final argument to the function.
`driver.setCookie(Cookie)` | Sets a cookie on the current page's domain. `Cookie = { name, value, path='/' }`
`driver.switchToDefaultFrame()` | Change focus to default content on the page.
`driver.switchToFrame(indexOrNameOrId)` | Change focus to another frame on the page.
`driver.getCurrentWindowHandle()` | Retrieve the current window handle.
`driver.switchToWindow(name)` | Change focus to another window. The window to change focus to may be specified by its
server assigned window handle, or by the value of its `name` attribute.
`driver.closeWindow()` | Close the current window.
`driver.getWindowSize(windowHandle)` | Get the size of the specified window. If no `windowHandle` in specified the current window is assumed. Returns an object with `width` and `height` values.
`driver.setWindowSize(width, height, windowHandle)` | Change the size of the specified window. If no `windowHandle` in specified the current window is assumed.
`driver.getWindowPosition(windowHandle)` | Get the position of the specified window. If no `windowHandle` in specified the current window is assumed. Returns an object with `x` and `y` values.
`driver.setWindowPosition(x, y, windowHandle)` | Change the position of the specified window. If no `windowHandle` in specified the current window is assumed.
`driver.maximizeWindow(windowHandle)` | Maximize the specified window if not already maximized. If no `windowHandle` in specified the current window is assumed.
`driver.getCookies()` | Returns all cookies visible to the current page.
`driver.clearCookies()` | Deletes all cookies visible to the current page.
`driver.setLocalStorageKey(key, value)` | Sets a local storage item for the current page.
`driver.getLocalStorageKeys()` | Returns all local storage keys visible to the current page.
`driver.clearLocalStorage()` | Deletes all local storage visible to the current page.
`driver.getConsoleLogs()` | Get browser console logs.
`driver.acceptAlert()` | Accepts the visable alert.
`driver.dismissAlert()` | Dismisses the visable alert.
`driver.getAlertText()` | Gets the visable alert's text.
`driver.typeAlert(text)` | Send `text` to the visable alert's input box.
`driver.getGeolocation()` | Returns the browser's HTML5 geolocation. Ex: `{latitude: 37.425, longitude: -122.136, altitude: 10.0}`. Not supported in all browsers.
`driver.setGeolocation(location)` | Set the browser's HTML5 geolocation. Expects `location` to be an object like `{latitude: 37.425, longitude: -122.136, altitude: 10.0}`. Not supported in all browsers.
`driver.buttonDown(button)` | Presses down the pointer button (default 0 = left, can be 1 = middle, 2 = right) at location of last `element.movePointerRelativeTo()`
`driver.buttonUp(button)` | Like `driver.buttonDown()`
`driver.click(button)` | Like `driver.buttonDown()`
`driver.close()` | Closes the WebDriver session.

### Element

`element = driver.getElement(selector)`

Method | Description
:----- | :----------
`element.get(attribute)` | Returns the element's specified attribute, which can be `text`, which returns the visible text of that element.
`element.getElement(cssSelector)` | Finds a child element of `element` using the `cssSelector` and returns an Element.
`element.getElements(cssSelector)` | Finds all child elements of the `element` using the `cssSelector` and returns an array of Elements.
`element.getLocation()` | Return an element's pixel location on the page. Ex: `{ y: 80, x: 406 }`
`element.getLocationInView()` | Return an element's pixel location on the screen once it has been scrolled into view. Ex: `{ y: 80, x: 406 }`
`element.getSize()` | Returns an element's size in pixels. Ex: `{ height: 207, width: 269 }`
`element.isVisible()` | Returns true if the element is visible.
`element.type(strings...)` | Sends `strings...` to the input element.
`element.clear()` | Clears the input element.
`element.click()` | Calls click on the element.
`element.movePointerRelativeTo(xOffset, yOffset)` | Moves the pointer to the coordinates given, relative to this element (default centered)

## Contributing

There are 97 WebDriver methods! The progress of implementing all of them is visualized below.

The most important and often used methods are already implemented. You can help out by implementing more methods.

Status | HTTP Method | Path  | Summary
:-----:| ----------- | ----- | -------
![not-yet] | GET | `/status` | Query the server's current status.
![impl] | POST | `/session` | Create a new session.
![not-yet] | GET | `/sessions` | Returns a list of the currently active sessions.
![not-yet] | GET | `/session/:sessionId` | Retrieve the capabilities of the specified session.
![impl] | DELETE | `/session/:sessionId` | Delete the session.
![impl] | POST | `/session/:sessionId/timeouts` |  Configure the amount of time that a particular type of operation can execute for before they are aborted and a `Timeout` error is returned to the client.
![impl] | POST | `/session/:sessionId/timeouts/async_script` | Set the amount of time, in milliseconds, that asynchronous scripts executed by `/session/:sessionId/execute_async` are permitted to run before they are aborted and a `Timeout` error is returned to the client.
![impl] | POST | `/session/:sessionId/timeouts/implicit_wait` |  Set the amount of time the driver should wait when searching for elements.
![impl] | GET | `/session/:sessionId/window_handle` | Retrieve the current window handle.
![not-yet] | GET | `/session/:sessionId/window_handles` |  Retrieve the list of all window handles available to the session.
![impl] | GET | `/session/:sessionId/url` | Retrieve the URL of the current page.
![impl] | POST | `/session/:sessionId/url` | Navigate to a new URL.
![not-yet] | POST | `/session/:sessionId/forward` | Navigate forwards in the browser history, if possible.
![not-yet] | POST | `/session/:sessionId/back` |  Navigate backwards in the browser history, if possible.
![not-yet] | POST | `/session/:sessionId/refresh` | Refresh the current page.
![impl] | POST | `/session/:sessionId/execute` | Inject a snippet of JavaScript into the page for execution in the context of the currently selected frame.
![impl] | POST | `/session/:sessionId/execute_async` | Inject a snippet of JavaScript into the page for execution in the context of the currently selected frame.
![impl] | GET | `/session/:sessionId/screenshot` |  Take a screenshot of the current page.
![not-yet] | GET | `/session/:sessionId/ime/available_engines` | List all available engines on the machine.
![not-yet] | GET | `/session/:sessionId/ime/active_engine` | Get the name of the active IME engine.
![not-yet] | GET | `/session/:sessionId/ime/activated` | Indicates whether IME input is active at the moment (not if it's available.
![not-yet] | POST | `/session/:sessionId/ime/deactivate` |  De-activates the currently-active IME engine.
![not-yet] | POST | `/session/:sessionId/ime/activate` |  Make an engines that is available (appears on the listreturned by getAvailableEngines) active.
![impl] | POST | `/session/:sessionId/frame` | Change focus to another frame on the page.
![impl] | POST | `/session/:sessionId/window` |  Change focus to another window.
![impl] | DELETE | `/session/:sessionId/window` |  Close the current window.
![impl] | POST | `/session/:sessionId/window/:windowHandle/size` | Change the size of the specified window.
![impl] | GET | `/session/:sessionId/window/:windowHandle/size` | Get the size of the specified window.
![impl] | POST | `/session/:sessionId/window/:windowHandle/position` | Change the position of the specified window.
![impl] | GET | `/session/:sessionId/window/:windowHandle/position` | Get the position of the specified window.
![impl] | POST | `/session/:sessionId/window/:windowHandle/maximize` | Maximize the specified window if not already maximized.
![impl] | GET | `/session/:sessionId/cookie` |  Retrieve all cookies visible to the current page.
![impl] | POST | `/session/:sessionId/cookie` |  Set a cookie.
![impl] | DELETE | `/session/:sessionId/cookie` |  Delete all cookies visible to the current page.
![not-yet] | DELETE | `/session/:sessionId/cookie/:name` |  Delete the cookie with the given name.
![impl] | GET | `/session/:sessionId/source` |  Get the current page source.
![impl] | GET | `/session/:sessionId/title` | Get the current page title.
![Partially Implemented](./docs/partially_implemented.png "Can only find via CSS selector") | POST | `/session/:sessionId/element` | Search for an element on the page with a CSS selector, starting from the document root.
![Partially Implemented](./docs/partially_implemented.png "Can only find via CSS selector") | POST | `/session/:sessionId/elements` | Search for multiple elements on the page with a CSS selector, starting from the document root.
![not-yet] | POST | `/session/:sessionId/element/active` |  Get the element on the page that currently has focus.
![not-yet] | GET | `/session/:sessionId/element/:id` | Describe the identified element.
![Partially Implemented](./docs/partially_implemented.png "Can only find via CSS selector") | POST | `/session/:sessionId/element/:id/element` | Search for an element on the page, starting from the identified element.
![Partially Implemented](./docs/partially_implemented.png "Can only find via CSS selector") | POST | `/session/:sessionId/element/:id/elements` |  Search for multiple elements on the page, starting from the identified element.
![impl] | POST | `/session/:sessionId/element/:id/click` | Click on an element.
![not-yet] | POST | `/session/:sessionId/element/:id/submit` |  Submit a FORM element.
![impl] | GET | `/session/:sessionId/element/:id/text` |  Returns the visible text for the element.
![Partially Implemented](./docs/partially_implemented.png "Does not support special characters") | POST | `/session/:sessionId/element/:id/value` | Send a sequence of key strokes to an element.
![not-yet] | POST | `/session/:sessionId/keys` |  Send a sequence of key strokes to the active element.
![not-yet] | GET | `/session/:sessionId/element/:id/name` |  Query for an element's tag name.
![impl] | POST | `/session/:sessionId/element/:id/clear` | Clear a TEXTAREA or text INPUT element's value.
![not-yet] | GET | `/session/:sessionId/element/:id/selected` |  Determine if an OPTION element, or an INPUT element of type checkbox or radiobutton is currently selected.
![not-yet] | GET | `/session/:sessionId/element/:id/enabled` | Determine if an element is currently enabled.
![impl] | GET | `/session/:sessionId/element/:id/attribute/:name` | Get the value of an element's attribute.
![not-yet] | GET | `/session/:sessionId/element/:id/equals/:other` | Test if two element IDs refer to the same DOM element.
![impl] | GET | `/session/:sessionId/element/:id/displayed` | Determine if an element is currently displayed.
![impl] | GET | `/session/:sessionId/element/:id/location` |  Determine an element's location on the page.
![impl] | GET | `/session/:sessionId/element/:id/location_in_view` |  Determine an element's location on the screen once it has been scrolled into view.
![impl] | GET | `/session/:sessionId/element/:id/size` |  Determine an element's size in pixels.
![not-yet] | GET | `/session/:sessionId/element/:id/css/:propertyName` | Query the value of an element's computed CSS property.
![not-yet] | GET | `/session/:sessionId/orientation` | Get the current browser orientation.
![not-yet] | POST | `/session/:sessionId/orientation` | Set the browser orientation.
![impl] | GET | `/session/:sessionId/alert_text` |  Gets the text of the currently displayed JavaScript alert(), confirm(), or prompt() dialog.
![impl] | POST | `/session/:sessionId/alert_text` |  Sends keystrokes to a JavaScript prompt() dialog.
![impl] | POST | `/session/:sessionId/accept_alert` |  Accepts the currently displayed alert dialog.
![impl] | POST | `/session/:sessionId/dismiss_alert` | Dismisses the currently displayed alert dialog.
![impl] | POST | `/session/:sessionId/moveto` |  Move the pointer by an offset of the specified element.
![impl] | POST | `/session/:sessionId/click` | Click any pointer button (at the coordinates set by the last moveto command).
![impl] | POST | `/session/:sessionId/buttondown` |  Click and hold the left pointer button (at the coordinates set by the last moveto command).
![impl] | POST | `/session/:sessionId/buttonup` |  Releases the pointer button previously held (where the pointer is currently at).
![not-yet] | POST | `/session/:sessionId/doubleclick` | Double-clicks at the current pointer coordinates (set by moveto).
![not-yet] | POST | `/session/:sessionId/touch/click` | Single tap on the touch enabled device.
![not-yet] | POST | `/session/:sessionId/touch/down` |  Finger down on the screen.
![not-yet] | POST | `/session/:sessionId/touch/up` |  Finger up on the screen.
![not-yet] | POST | `session/:sessionId/touch/move` | Finger move on the screen.
![not-yet] | POST | `session/:sessionId/touch/scroll` | Scroll on the touch screen using finger based motion events.
![not-yet] | POST | `session/:sessionId/touch/scroll` | Scroll on the touch screen using finger based motion events.
![not-yet] | POST | `session/:sessionId/touch/doubleclick` |  Double tap on the touch screen using finger motion events.
![not-yet] | POST | `session/:sessionId/touch/longclick` |  Long press on the touch screen using finger motion events.
![not-yet] | POST | `session/:sessionId/touch/flick` |  Flick on the touch screen using finger motion events.
![not-yet] | POST | `session/:sessionId/touch/flick` |  Flick on the touch screen using finger motion events.
![impl] | GET | `/session/:sessionId/location` |  Get the current geo location.
![impl] | POST | `/session/:sessionId/location` |  Set the current geo location.
![impl] | GET | `/session/:sessionId/local_storage` | Get all keys of the storage.
![impl] | POST | `/session/:sessionId/local_storage` | Set the storage item for the given key.
![impl] | DELETE | `/session/:sessionId/local_storage` | Clear the storage.
![not-yet] | GET | `/session/:sessionId/local_storage/key/:key` |  Get the storage item for the given key.
![not-yet] | DELETE | `/session/:sessionId/local_storage/key/:key` |  Remove the storage item for the given key.
![not-yet] | GET | `/session/:sessionId/local_storage/size` |  Get the number of items in the storage.
![not-yet] | GET | `/session/:sessionId/session_storage` | Get all keys of the storage.
![not-yet] | POST | `/session/:sessionId/session_storage` | Set the storage item for the given key.
![not-yet] | DELETE | `/session/:sessionId/session_storage` | Clear the storage.
![not-yet] | GET | `/session/:sessionId/session_storage/key/:key` |  Get the storage item for the given key.
![not-yet] | DELETE | `/session/:sessionId/session_storage/key/:key` |  Remove the storage item for the given key.
![not-yet] | GET | `/session/:sessionId/session_storage/size` |  Get the number of items in the storage.
![impl] | POST | `/session/:sessionId/log` | Get the log for a given log type.
![not-yet] | GET | `/session/:sessionId/log/types` | Get available log types.
![not-yet] | GET | `/session/:sessionId/application_cache/status` |  Get the status of the html5 application cache.


[impl]: ./docs/implemented.png "Implemented"
[not-yet]: ./docs/not_implemented.png "Not Yet Implemented"
