
/*
Copyright (c) 2013, Groupon, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

Neither the name of GROUPON nor the names of its contributors may be
used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
var WebDriver, assert, buildRequester, createAlertApi, createCookieApi, createDebugApi, createElementApi, createLocalStorageApi, createLocationApi, createNavigationApi, createPageApi, createPointerApi, createSession, createWindowApi, extend, http, parseResponseData,
  slice = [].slice;

assert = require('assertive');

http = require('./http');

extend = require('lodash').extend;

parseResponseData = require('./parse_response');

createSession = require('./session');

buildRequester = require('./request');

createAlertApi = require('./alert_api');

createCookieApi = require('./cookie_api');

createDebugApi = require('./debug_api');

createElementApi = require('./element_api');

createLocalStorageApi = require('./local_storage_api');

createLocationApi = require('./location_api');

createNavigationApi = require('./navigation_api');

createPageApi = require('./page_api');

createPointerApi = require('./pointer_api');

createWindowApi = require('./window_api');

module.exports = WebDriver = (function() {
  function WebDriver(serverUrl, desiredCapabilities, httpOptions) {
    var ref, request, sessionId;
    if (httpOptions == null) {
      httpOptions = {};
    }
    assert.truthy('new WebDriver(serverUrl, desiredCapabilities, httpOptions) - requires serverUrl', serverUrl);
    assert.truthy('new WebDriver(serverUrl, desiredCapabilities, httpOptions) - requires desiredCapabilities', desiredCapabilities);
    request = buildRequester(httpOptions);
    ref = createSession(request, serverUrl, desiredCapabilities), sessionId = ref.sessionId, this.capabilities = ref.capabilities;
    this.http = http(request, serverUrl, sessionId);
    extend(this, createAlertApi(this.http));
    extend(this, createCookieApi(this.http));
    extend(this, createDebugApi(this.http));
    extend(this, createElementApi(this.http));
    extend(this, createLocalStorageApi(this.http));
    extend(this, createLocationApi(this.http));
    extend(this, createNavigationApi(this.http));
    extend(this, createPageApi(this.http));
    extend(this, createPointerApi(this.http));
    extend(this, createWindowApi(this.http));
  }

  WebDriver.prototype.on = function(event, callback) {
    if (event !== 'request' && event !== 'response') {
      throw new Error("Invalid event name '" + event + "'. WebDriver only emits 'request' and 'response' events.");
    }
    return this.http.on(event, callback);
  };

  WebDriver.prototype.close = function() {
    this.http["delete"]('');
  };

  WebDriver.prototype.getCapabilities = function() {
    var response;
    response = this.http.get('');
    return parseResponseData(response);
  };

  WebDriver.prototype.setTimeouts = function(type, ms) {
    this.http.post("/timeouts", {
      type: type,
      ms: ms
    });
  };

  WebDriver.prototype.setScriptTimeout = function(ms) {
    this.http.post("/timeouts/async_script", {
      ms: ms
    });
  };

  WebDriver.prototype.evaluate = function(clientFunctionString) {
    var args, error, friendlyError, response;
    if (arguments.length > 1) {
      clientFunctionString = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    }
    if (typeof clientFunctionString === 'function') {
      clientFunctionString = 'return (' + clientFunctionString + ').apply(this, arguments)';
    }
    response = this.http.post("/execute", {
      script: clientFunctionString,
      args: args != null ? args : []
    });
    try {
      return parseResponseData(response);
    } catch (error1) {
      error = error1;
      friendlyError = new Error("Error evaluating JavaScript: " + clientFunctionString + "\n" + error.message);
      friendlyError.inner = error;
      throw friendlyError;
    }
  };

  WebDriver.prototype.evaluateAsync = function(clientFunctionString) {
    var args, error, friendlyError, response;
    if (arguments.length > 1) {
      clientFunctionString = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    }
    if (typeof clientFunctionString === 'function') {
      clientFunctionString = 'return (' + clientFunctionString + ').apply(this, arguments)';
    }
    response = this.http.post("/execute_async", {
      script: clientFunctionString,
      args: args != null ? args : []
    });
    try {
      return parseResponseData(response);
    } catch (error1) {
      error = error1;
      friendlyError = new Error("Error evaluating JavaScript: " + clientFunctionString + "\n" + error.message);
      friendlyError.inner = error;
      throw friendlyError;
    }
  };

  WebDriver.prototype.sendKeys = function() {
    var strings;
    strings = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    this.http.post('/keys', {
      value: strings
    });
  };

  return WebDriver;

})();
