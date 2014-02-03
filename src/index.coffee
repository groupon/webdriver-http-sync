###
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
###

assert = require 'assertive'
http = require './http'
{extend} = require 'underscore'
parseResponseData = require './parse_response'
createSession = require './session'
buildRequester = require './request'

createAlertApi = require './alert_api'
createCookieApi = require './cookie_api'
createElementApi = require './element_api'
createNavigationApi = require './navigation_api'
createPageApi = require './page_api'
createDebugApi = require './debug_api'

module.exports = class WebDriver
  constructor: (serverUrl, desiredCapabilities, httpOptions={}) ->
    assert.truthy 'new WebDriver(serverUrl, desiredCapabilities, httpOptions) - requires serverUrl', serverUrl
    assert.truthy 'new WebDriver(serverUrl, desiredCapabilities, httpOptions) - requires desiredCapabilities', desiredCapabilities

    request = buildRequester(httpOptions)

    {sessionId, @capabilities} = createSession(request, serverUrl, desiredCapabilities)
    @http = http(request, serverUrl, sessionId)

    extend this, createAlertApi(@http)
    extend this, createCookieApi(@http)
    extend this, createElementApi(@http)
    extend this, createNavigationApi(@http)
    extend this, createPageApi(@http)
    extend this, createDebugApi(@http)

  on: (event, callback) ->
    if event not in ['request', 'response']
      throw new Error "Invalid event name '#{event}'. WebDriver only emits 'request' and 'response' events."
    @http.on event, callback

  close: ->
    # delete session
    @http.delete '/'
    return

  evaluate: (clientFunctionString) ->
    response = @http.post "/execute",
      script: clientFunctionString
      args: []

    try
      return parseResponseData(response)
    catch error
      friendlyError = new Error "Error evaluating JavaScript: #{clientFunctionString}\n#{error.message}"
      friendlyError.inner = error
      throw friendlyError

