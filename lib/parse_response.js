
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
var cleanResponse, createDetailError, debug, json, logWarning, omit, validateResponse;

omit = require('lodash').omit;

debug = require('debug')('webdriver-http-sync:parse_response');

json = require('./json');

cleanResponse = function(response) {
  delete response.screen;
  delete response.hCode;
  return delete response["class"];
};

createDetailError = function(message) {
  var detailError, details, key, value;
  if (message[0] === '{') {
    details = json.tryParse(message);
    if (typeof (details != null ? details.errorMessage : void 0) === 'string') {
      detailError = new Error(details.errorMessage);
      for (key in details) {
        value = details[key];
        if (key !== 'errorMessage') {
          detailError[key] = value;
        }
      }
      return detailError;
    }
  }
  return new Error(message);
};

logWarning = function(message) {
  var details;
  if (message[0] === '{') {
    details = json.tryParse(message);
    if (typeof (details != null ? details.errorMessage : void 0) === 'string') {
      return debug(details.errorMessage, omit(details, 'errorMessage'));
    } else {
      return debug(details);
    }
  } else {
    return debug(message);
  }
};

validateResponse = function(response) {
  var friendlyError;
  if (response.message == null) {
    return;
  }
  if (response.stackTrace == null) {
    return logWarning(response.message);
  }
  friendlyError = createDetailError(response.message);
  friendlyError.inner = response;
  throw friendlyError;
};

module.exports = function(response) {
  var data;
  if (response.body.length === 0) {
    return null;
  }
  data = response.body.toString();
  response = (json.tryParse(data)).value;
  if (response != null) {
    cleanResponse(response);
    validateResponse(response);
  }
  return response;
};
