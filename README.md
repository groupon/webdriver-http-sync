# webdriver-http-sync

Sync implementation of the
[WebDriver protocol](https://code.google.com/p/selenium/wiki/JsonWireProtocol)
in Node.js.

Keep up to date with changes
by checking the
[releases](https://github.com/groupon-testium/webdriver-http-sync/releases).

## Install

On Ubuntu, you need to make sure you have libcurl installed.
`sudo apt-get install libcurl4-openssl-dev`

```bash
npm install webdriver-http-sync
```

## WebDriver API

### WebDriver

`driver = new WebDriver(serverUrl, desiredCapabilities, httpOptions)`

Method | Description
:----- | :----------
`driver.navigateTo(url)` | Navigates the browser to the specificed relative or absolute url. If relative, the root is assumed to be `http://127.0.0.1:#{applicationPort}`, where `applicationPort` is passed in to the options for `testium.runTests`.
`driver.refresh()` | Refreshes the browser.
`driver.getElement(cssSelector)` | Finds an element on the page using the `cssSelector` and returns an Element.
`driver.getElements(cssSelector)` | Finds all elements on the page using the `cssSelector` and returns an array of Elements.
`driver.setElementTimeout(milliseconds)` | Sets a timeout for WebDriver to find elements with `getElement` and `getElements`.
`driver.getUrl()` | Returns the current url of the page.
`driver.getPageTitle()` | Returns the current page title.
`driver.getPageSource()` | Returns the current page's html source.
`driver.getScreenshot()` | Returns screenshot as a base64 encoded PNG.
`driver.evaluate(javascriptString)` | Executes the given javascript. It must contain a return statement in order to get a value back.
`driver.setCookie(Cookie)` | Sets a cookie on the current page's domain. `Cookie = { name, value, path='/' }`
`driver.getCookies()` | Returns all cookies visible to the current page.
`driver.clearCookies()` | Deletes all cookies visible to the current page.
`driver.acceptAlert()` | Accepts the visable alert.
`driver.dismissAlert()` | Dismisses the visable alert.
`driver.getAlertText()` | Gets the visable alert's text.
`driver.typeAlert(text)` | Send `text` to the visable alert's input box.
`driver.close()` | Closes the WebDriver session.

### Element

`element = driver.getElement(selector)`

Method | Description
:----- | :----------
`element.get(attribute)` | Returns the element's specified attribute, which can be `text`, which returns the visisble text of that element.
`element.isVisible()` | Returns true if the element is visible.
`element.type(strings...)` | Sends `strings...` to the input element.
`element.clear()` | Clears the input element.
`element.click()` | Calls click on the element.

## Contributing

There are 97 WebDriver methods! The progress of implementing all of them is visualized below.

The most important and often used methods are already implemented. You can help out by implementing more methods.

Status | HTTP Method | Path  | Summary
:-----:| ----------- | ----- | -------
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/status` | Query the server's current status.
![Implemented](./docs/implemented.png "Implemented") | POST | `/session` | Create a new session.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/sessions` | Returns a list of the currently active sessions.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId` | Retrieve the capabilities of the specified session.
![Implemented](./docs/implemented.png "Implemented") | DELETE | `/session/:sessionId` | Delete the session.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/timeouts` |  Configure the amount of time that a particular type of operation can execute for before they are aborted and a `Timeout` error is returned to the client.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/timeouts/async_script` | Set the amount of time, in milliseconds, that asynchronous scripts executed by `/session/:sessionId/execute_async` are permitted to run before they are aborted and a `Timeout` error is returned to the client.
![Implemented](./docs/implemented.png "Implemented") | POST | `/session/:sessionId/timeouts/implicit_wait` |  Set the amount of time the driver should wait when searching for elements.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/window_handle` | Retrieve the current window handle.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/window_handles` |  Retrieve the list of all window handles available to the session.
![Implemented](./docs/implemented.png "Implemented") | GET | `/session/:sessionId/url` | Retrieve the URL of the current page.
![Implemented](./docs/implemented.png "Implemented") | POST | `/session/:sessionId/url` | Navigate to a new URL.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/forward` | Navigate forwards in the browser history, if possible.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/back` |  Navigate backwards in the browser history, if possible.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/refresh` | Refresh the current page.
![Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/execute` | Inject a snippet of JavaScript into the page for execution in the context of the currently selected frame.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/execute_async` | Inject a snippet of JavaScript into the page for execution in the context of the currently selected frame.
![Implemented](./docs/implemented.png "Implemented") | GET | `/session/:sessionId/screenshot` |  Take a screenshot of the current page.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/ime/available_engines` | List all available engines on the machine.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/ime/active_engine` | Get the name of the active IME engine.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/ime/activated` | Indicates whether IME input is active at the moment (not if it's available.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/ime/deactivate` |  De-activates the currently-active IME engine.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/ime/activate` |  Make an engines that is available (appears on the listreturned by getAvailableEngines) active.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/frame` | Change focus to another frame on the page.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/window` |  Change focus to another window.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | DELETE | `/session/:sessionId/window` |  Close the current window.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/window/:windowHandle/size` | Change the size of the specified window.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/window/:windowHandle/size` | Get the size of the specified window.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/window/:windowHandle/position` | Change the position of the specified window.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/window/:windowHandle/position` | Get the position of the specified window.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/window/:windowHandle/maximize` | Maximize the specified window if not already maximized.
![Implemented](./docs/implemented.png "Implemented") | GET | `/session/:sessionId/cookie` |  Retrieve all cookies visible to the current page.
![Implemented](./docs/implemented.png "Implemented") | POST | `/session/:sessionId/cookie` |  Set a cookie.
![Implemented](./docs/implemented.png "Implemented") | DELETE | `/session/:sessionId/cookie` |  Delete all cookies visible to the current page.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | DELETE | `/session/:sessionId/cookie/:name` |  Delete the cookie with the given name.
![Implemented](./docs/implemented.png "Implemented") | GET | `/session/:sessionId/source` |  Get the current page source.
![Implemented](./docs/implemented.png "Implemented") | GET | `/session/:sessionId/title` | Get the current page title.
![Partially Implemented](./docs/partially_implemented.png "Can only find via CSS selector") | POST | `/session/:sessionId/element` | Search for an element on the page with a CSS selector, starting from the document root.
![Partially Implemented](./docs/partially_implemented.png "Can only find via CSS selector") | POST | `/session/:sessionId/elements` | Search for multiple elements on the page with a CSS selector, starting from the document root.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/element/active` |  Get the element on the page that currently has focus.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/element/:id` | Describe the identified element.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/element/:id/element` | Search for an element on the page, starting from the identified element.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/element/:id/elements` |  Search for multiple elements on the page, starting from the identified element.
![Implemented](./docs/implemented.png "Implemented") | POST | `/session/:sessionId/element/:id/click` | Click on an element.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/element/:id/submit` |  Submit a FORM element.
![Implemented](./docs/implemented.png "Implemented") | GET | `/session/:sessionId/element/:id/text` |  Returns the visible text for the element.
![Partially Implemented](./docs/partially_implemented.png "Does not support special characters") | POST | `/session/:sessionId/element/:id/value` | Send a sequence of key strokes to an element.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/keys` |  Send a sequence of key strokes to the active element.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/element/:id/name` |  Query for an element's tag name.
![Implemented](./docs/implemented.png "Implemented") | POST | `/session/:sessionId/element/:id/clear` | Clear a TEXTAREA or text INPUT element's value.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/element/:id/selected` |  Determine if an OPTION element, or an INPUT element of type checkbox or radiobutton is currently selected.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/element/:id/enabled` | Determine if an element is currently enabled.
![Implemented](./docs/implemented.png "Implemented") | GET | `/session/:sessionId/element/:id/attribute/:name` | Get the value of an element's attribute.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/element/:id/equals/:other` | Test if two element IDs refer to the same DOM element.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/element/:id/displayed` | Determine if an element is currently displayed.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/element/:id/location` |  Determine an element's location on the page.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/element/:id/location_in_view` |  Determine an element's location on the screen once it has been scrolled into view.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/element/:id/size` |  Determine an element's size in pixels.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/element/:id/css/:propertyName` | Query the value of an element's computed CSS property.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/orientation` | Get the current browser orientation.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/orientation` | Set the browser orientation.
![Implemented](./docs/implemented.png "Implemented") | GET | `/session/:sessionId/alert_text` |  Gets the text of the currently displayed JavaScript alert(), confirm(), or prompt() dialog.
![Implemented](./docs/implemented.png "Implemented") | POST | `/session/:sessionId/alert_text` |  Sends keystrokes to a JavaScript prompt() dialog.
![Implemented](./docs/implemented.png "Implemented") | POST | `/session/:sessionId/accept_alert` |  Accepts the currently displayed alert dialog.
![Implemented](./docs/implemented.png "Implemented") | POST | `/session/:sessionId/dismiss_alert` | Dismisses the currently displayed alert dialog.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/moveto` |  Move the mouse by an offset of the specificed element.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/click` | Click any mouse button (at the coordinates set by the last moveto command).
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/buttondown` |  Click and hold the left mouse button (at the coordinates set by the last moveto command).
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/buttonup` |  Releases the mouse button previously held (where the mouse is currently at).
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/doubleclick` | Double-clicks at the current mouse coordinates (set by moveto).
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/touch/click` | Single tap on the touch enabled device.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/touch/down` |  Finger down on the screen.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/touch/up` |  Finger up on the screen.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `session/:sessionId/touch/move` | Finger move on the screen.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `session/:sessionId/touch/scroll` | Scroll on the touch screen using finger based motion events.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `session/:sessionId/touch/scroll` | Scroll on the touch screen using finger based motion events.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `session/:sessionId/touch/doubleclick` |  Double tap on the touch screen using finger motion events.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `session/:sessionId/touch/longclick` |  Long press on the touch screen using finger motion events.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `session/:sessionId/touch/flick` |  Flick on the touch screen using finger motion events.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `session/:sessionId/touch/flick` |  Flick on the touch screen using finger motion events.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/location` |  Get the current geo location.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/location` |  Set the current geo location.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/local_storage` | Get all keys of the storage.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/local_storage` | Set the storage item for the given key.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | DELETE | `/session/:sessionId/local_storage` | Clear the storage.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/local_storage/key/:key` |  Get the storage item for the given key.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | DELETE | `/session/:sessionId/local_storage/key/:key` |  Remove the storage item for the given key.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/local_storage/size` |  Get the number of items in the storage.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/session_storage` | Get all keys of the storage.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/session_storage` | Set the storage item for the given key.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | DELETE | `/session/:sessionId/session_storage` | Clear the storage.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/session_storage/key/:key` |  Get the storage item for the given key.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | DELETE | `/session/:sessionId/session_storage/key/:key` |  Remove the storage item for the given key.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/session_storage/size` |  Get the number of items in the storage.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | POST | `/session/:sessionId/log` | Get the log for a given log type.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/log/types` | Get available log types.
![Not Yet Implemented](./docs/not_implemented.png "Not Yet Implemented") | GET | `/session/:sessionId/application_cache/status` |  Get the status of the html5 application cache.

