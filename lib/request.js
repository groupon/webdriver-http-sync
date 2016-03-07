
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
var CONNECT_TIMEOUT, HEADER_LINE, STATUS_LINE, TIMEOUT, curl, debug, extend, parseHeaders;

extend = require('lodash').extend;

debug = require('debug')('webdriver-http-sync:request');

curl = require('bindings')('curllib.node').curl;

TIMEOUT = 60000;

CONNECT_TIMEOUT = 2000;

STATUS_LINE = /HTTP\/[0-9].[0-9] ([0-9]{3})/;

HEADER_LINE = /([^:]+):[\s]*([^\r\n]*)/;

parseHeaders = function(headerLines) {
  var headers, statusCode;
  statusCode = 200;
  headers = {};
  headerLines.forEach(function(line) {
    var entry, match, name, value;
    match = line.match(STATUS_LINE);
    if (match) {
      return statusCode = parseInt(match[1], 10);
    } else {
      match = line.match(HEADER_LINE);
      if (match == null) {
        return;
      }
      line = match[0], name = match[1], value = match[2];
      name = name.toLowerCase();
      entry = headers[name];
      if (entry) {
        if (typeof entry === 'string') {
          headers[name] = [entry];
        }
        return headers[name].push(value);
      } else {
        return headers[name] = value;
      }
    }
  });
  return {
    statusCode: statusCode,
    headers: headers
  };
};

module.exports = function(arg) {
  var connectTimeout, ref, timeout;
  ref = arg != null ? arg : {}, timeout = ref.timeout, connectTimeout = ref.connectTimeout;
  if (timeout == null) {
    timeout = TIMEOUT;
  }
  if (connectTimeout == null) {
    connectTimeout = CONNECT_TIMEOUT;
  }
  return function(url, method, data) {
    var body, elapsed, err, error, headers, ref1, requestBody, response, startTime;
    if (method == null) {
      method = 'GET';
    }
    if (data == null) {
      data = null;
    }
    debug('%s %s', method, url, data);
    startTime = Date.now();
    try {
      requestBody = data != null ? JSON.stringify(data) : '';
      response = curl({
        method: (ref1 = method != null ? method.toUpperCase() : void 0) != null ? ref1 : 'GET',
        url: url,
        body: requestBody,
        connectTimeout: connectTimeout,
        timeout: timeout,
        headers: ['Content-Type: application/json', "Content-Length: " + (Buffer.byteLength(requestBody))]
      });
    } catch (error) {
      err = error;
      if (err.code !== 'ETIMEDOUT') {
        throw err;
      }
      elapsed = Date.now() - startTime;
      throw new Error("Request timed out after " + elapsed + "ms to: " + url);
    }
    headers = response.headers, body = response.body;
    return extend(parseHeaders(headers), {
      body: body.toString()
    });
  };
};
