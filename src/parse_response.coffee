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

{omit} = require 'lodash'
debug = require('debug')('webdriver-http-sync:parse_response')

json = require './json'

cleanResponse = (response) ->
  delete response.screen
  delete response.hCode # unhelpful selenium noise
  delete response.class # unhelpful selenium noise

createDetailError = (message) ->
  if message[0] == '{'
    details = json.tryParse message
    if typeof details?.errorMessage == 'string'
      detailError = new Error details.errorMessage

      for key, value of details
        detailError[key] = value if key != 'errorMessage'

      return detailError

  new Error message

logWarning = (message) ->
  if message[0] == '{'
    details = json.tryParse message
    if typeof details?.errorMessage == 'string'
      debug details.errorMessage, omit(details, 'errorMessage')
    else
      debug details
  else
    debug message

validateResponse = (response) ->
  return unless response.message?

  return logWarning(response.message) unless response.stackTrace?

  friendlyError = createDetailError response.message
  friendlyError.inner = response
  throw friendlyError

module.exports = (response) ->
  return null if response.body.length is 0

  data = response.body.toString()
  response = (json.tryParse data).value

  if response?
    cleanResponse(response)
    validateResponse(response)

  response

