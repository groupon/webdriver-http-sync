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

httpsync = require 'http-sync'
_ = require 'underscore'
assert = require 'assertive'
parseUrl = require('url').parse
json = require './json'
{EventEmitter} = require 'events'

TIMEOUT = 60000
CONNECT_TIMEOUT = 2000

normalizeUrl = (serverUrl, sessionRoot, url) ->
  if url.indexOf('http') == 0
    url
  else
    serverUrl + sessionRoot + url

emitter = new EventEmitter
log = (message) ->
  emitter.emit 'request', message
verbose = (message) ->
  emitter.emit 'response', message

registerEventHandler = (event, callback) ->
  if event not in ['request', 'response']
    throw new Error "Invalid event name '#{event}'. The WebDriver http module only emits 'request' and 'response' events."
  emitter.on event, callback

getProtocol = (protocolPart) ->
  protocolPart.replace(/:$/, '')

getUrlParts = (url) ->
  parts = parseUrl(url)

  # the translations done here are based on the
  # expectations of http-sync
  {
    port: parts.port
    path: parts.path

    # port must not be included
    host: parts.hostname

    # trailing `:` must not be included
    protocol: getProtocol(parts.protocol)
  }

makeRequest = (request, data) ->
  if data
    request.end(data)
  else
    request.end()

createSession = (http, desiredCapabilities) ->
  response = http.post '/session', { desiredCapabilities }
  assert.equal 'Failed to start Selenium session. Check the selenium.log.', response.statusCode, 200

  sessionId = (json.tryParse response.body).sessionId
  assert.truthy sessionId
  sessionId

module.exports = (serverUrl, desiredCapabilities, {timeout, connectTimeout})   ->
  timeout ?= TIMEOUT
  connectTimeout ?= CONNECT_TIMEOUT
  sessionRoot = '' # populated below!

  request = (url, method='get', data=null) ->
    options = {
      method
    }

    options = _.extend {}, options, getUrlParts(url)

    httpSyncRequest = httpsync.request(options)

    httpSyncRequest.setTimeout timeout, ->
      throw new Error "Request timed out after #{timeout}ms to: #{url}"
    httpSyncRequest.setConnectTimeout connectTimeout, ->
      throw new Error "Request connection timed out after #{connectTimeout}ms to: #{url}"

    makeRequest(httpSyncRequest, data)

  get = (url) ->
    url = normalizeUrl(serverUrl, sessionRoot, url)
    log "[WEB] GET #{url}"
    response = request(url)
    verbose response
    response

  post = (url, data={}) ->
    url = normalizeUrl(serverUrl, sessionRoot, url)
    method = 'POST'
    log "[WEB] POST #{url}"
    data = JSON.stringify(data)
    response = request(url, method, data)
    verbose response
    response

  del = (url) ->
    url = normalizeUrl(serverUrl, sessionRoot, url)
    method = 'DELETE'
    log "[WEB] DELETE #{url}"
    response = request(url, method)
    verbose response
    response

  http = {
    get
    post
    delete: del
    on: registerEventHandler
  }

  sessionId = createSession(http, desiredCapabilities)
  sessionRoot = "/session/#{sessionId}"

  return http

