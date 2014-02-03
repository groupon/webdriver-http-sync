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
{extend} = require 'underscore'
parseUrl = require('url').parse

TIMEOUT = 60000
CONNECT_TIMEOUT = 2000

makeRequest = (request, data) ->
  if data
    request.end(data)
  else
    request.end()

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

module.exports = ({timeout, connectTimeout}) ->
  timeout ?= TIMEOUT
  connectTimeout ?= CONNECT_TIMEOUT

  (url, method='get', data=null) ->
    options = {
      method
    }

    options = extend {}, options, getUrlParts(url)

    httpSyncRequest = httpsync.request(options)

    httpSyncRequest.setTimeout timeout, ->
      throw new Error "Request timed out after #{timeout}ms to: #{url}"
    httpSyncRequest.setConnectTimeout connectTimeout, ->
      throw new Error "Request connection timed out after #{connectTimeout}ms to: #{url}"

    makeRequest(httpSyncRequest, data)

