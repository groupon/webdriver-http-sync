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

{extend} = require 'lodash'
debug = require('debug')('webdriver-http-sync:request')

{curl} = require('bindings')('curllib.node')

TIMEOUT = 60000
CONNECT_TIMEOUT = 2000

STATUS_LINE = /HTTP\/[0-9].[0-9] ([0-9]{3})/
HEADER_LINE = /([^:]+):[\s]*([^\r\n]*)/

parseHeaders = (headerLines) ->
  statusCode = 200
  headers = {}
  headerLines.forEach (line) ->
    match = line.match STATUS_LINE
    if match
      statusCode = parseInt(match[1], 10)
    else
      match = line.match HEADER_LINE
      return unless match?
      [line, name, value] = match
      name = name.toLowerCase()
      entry = headers[name]
      if entry
        if typeof entry == 'string'
          headers[name] = [entry]
        headers[name].push value
      else
        headers[name] = value

  return { statusCode, headers }

module.exports = ({timeout, connectTimeout} = {}) ->
  timeout ?= TIMEOUT
  connectTimeout ?= CONNECT_TIMEOUT

  (url, method='GET', data=null) ->
    debug '%s %s', method, url, data

    startTime = Date.now()
    try
      requestBody = if data? then JSON.stringify data else ''
      response = curl {
        method: method?.toUpperCase() ? 'GET'
        url: url
        body: requestBody
        connectTimeout: connectTimeout
        timeout: timeout
        headers: [
          'Content-Type: application/json'
          "Content-Length: #{Buffer.byteLength requestBody}"
        ]
      }
    catch err
      throw err unless err.code == 'ETIMEDOUT'
      elapsed = Date.now() - startTime
      throw new Error "Request timed out after #{elapsed}ms to: #{url}"

    {headers, body} = response
    extend parseHeaders(headers), { body: body.toString() }
