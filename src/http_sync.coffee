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

caseless = require 'caseless'
{map} = require 'lodash'

{CurlLib} = require('bindings')('curllib.node')

curllib = new CurlLib()

_1_hr_in_ms = 1 * 60 * 60 * 1000;

class CurlRequest
  constructor: (options) ->
    @_options = options
    @_headers = {}
    @_caseless = caseless @_headers

    for name, header of @_options.headers
      @setHeader name, header

  getHeader: (name) ->
    @_caseless.get name

  removeHeader: (name) ->
    @_caseless.del name

  setHeader: (name, value) ->
    @_caseless.set name, value

  write: (data) ->
    data ||= '';
    @_options.body += data;

  setTimeout: (msec, callback) ->
    msec = msec || 0
    @_options._timeout = { msec, callback }

  setConnectTimeout: (msec, callback) ->
    msec = msec || 0
    @_options._connect_timeout = { msec, callback }

  _buildUrl: ->
    return @_options.url if @_options.url
    {protocol, host, port, path} = @_options
    "#{protocol}://#{host}:#{port}#{path}"

  end: (data) ->
    @write data

    _ep = @_buildUrl()
    _h = map @_headers, (header, name) -> "#{name}: #{header}"

    _timeout_ms = @_options._timeout?.msec ? _1_hr_in_ms
    _connect_timeout_ms = @_options._connect_timeout?.msec ? _1_hr_in_ms

    ret = curllib.run {
      method: @_options.method,
      url: _ep,
      headers: _h,
      body: @_options.body,
      connect_timeout_ms: _connect_timeout_ms,
      timeout_ms: _timeout_ms,
      rejectUnauthorized: @_options.rejectUnauthorized,
      cert : @_options.cert,
      pfx : @_options.pfx,
      passphrase : @_options.passphrase,
      key : @_options.key,
      ca : @_options.ca
    }

    if ret.timedout
      # If both connect and (other) timeout are set, only
      # invoke the connect timeout since we have no way of
      # knowing which one fired.
      if @_options._connect_timeout
        @_options._connect_timeout.callback()
      else
        @_options._timeout.callback()
      return
    else if ret.error
      throw new Error ret.error

    ret.body = ''
    if ret.body_length
      _b = new Buffer ret.body_length
      ret.body = curllib.body _b

    _parse_headers = (headers) ->
      _sre = /HTTP\/[0-9].[0-9] ([0-9]{3})/
      _hre = /([^:]+):([\s]*)([^\r\n]*)/
      statusCode = 200
      _h = {}
      headers.forEach (line) ->
        _m = line.match _sre
        if _m
          statusCode = _m[1]
        else
          _m = line.match _hre
          if _m
            header = _m[1]
            entry = _h[header]
            value = _m[3]
            if entry
              if typeof entry == 'string'
                _h[header] = [entry]
              _h[header].push(value);
            else
              _h[header] = value;

      return {
        statusCode: parseInt(statusCode, 10)
        headers: _h
      }

    _ph = _parse_headers ret.headers
    ret.statusCode = _ph.statusCode
    ret.headers = _ph.headers

    return ret

module.exports = request = (options) ->
  options.method = options.method?.toUpperCase() ? 'GET'

  options.protocol = (options.protocol || 'http').replace(/:$/, '')
  options.port = options.port || (if options.protocol == 'https' then 443 else 80)
  options.path = options.path || '/'
  options.headers = options.headers || {}
  options.host = options.host || '127.0.0.1'
  options.body = options.body || ''
  if options.auth && !options.headers['Authorization']
    # basic auth
    options.headers['Authorization'] = 'Basic ' + new Buffer(options.auth).toString('base64')
  options.rejectUnauthorized = options.rejectUnauthorized != false

  new CurlRequest options
