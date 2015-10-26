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

http = require './http'
assert = require 'assertive'
json = require './json'
parseResponseData = require './parse_response'
{inspect} = require 'util'

NOT_FOUND_MESSAGE = new RegExp([
  'Unable to locate element', # firefox message
  'Unable to find element', # phantomjs message
  'no such element', # chrome message
].join '|')

createElement = (http, selector, root) ->
  response = http.post "#{root}/element",
    using: 'css selector'
    value: selector

  parseElement http, parseResponseData(response).ELEMENT

createElements = (http, selector, root) ->
  response = http.post "#{root}/elements",
    using: 'css selector'
    value: selector

  elements = parseResponseData(response)
  parseElement(http, element.ELEMENT) for element in elements

parseElement = (http, elementId) ->
  if elementId
    new Element(http, elementId)
  else
    null

module.exports = class Element
  constructor: (@http, @elementId) ->
    assert.truthy 'new Element(http, elementId) - requires http', @http
    assert.truthy 'new Element(http, elementId) - requires elementId', @elementId

    @root = "/element/#{@elementId}"

  # for use in console
  inspect: ->
    inspect @constructor.prototype

  get: (attribute) ->
    assert.truthy 'get(attribute) - requires attribute', attribute

    pathname =
      if attribute == 'text'
        "#{@root}/text"
      else
        "#{@root}/attribute/#{attribute}"

    response = @http.get pathname
    parseResponseData response

  getElement: (selector) ->
    elementOrNull =>
      createElement @http, selector, @root

  getElements: (selector) ->
    createElements @http, selector, @root

  getLocation: ->
    response = @http.get "#{@root}/location"
    parseResponseData response

  getLocationInView: ->
    response = @http.get "#{@root}/location_in_view"
    parseResponseData response

  getSize: ->
    response = @http.get "#{@root}/size"
    parseResponseData response

  isVisible: ->
    response = @http.get "#{@root}/displayed"
    data = response.body?.toString()
    json.tryParse(data).value

  click: ->
    @http.post "#{@root}/click"
    return

  type: (strings...) ->
    assert.truthy 'type(strings) - requires strings', strings
    @http.post "#{@root}/value", {value: strings}
    return

  clear: ->
    @http.post "#{@root}/clear"
    return

elementOrNull = Element.elementOrNull = (create) ->
  try
    create()
  catch error
    return null if NOT_FOUND_MESSAGE.test error.toString()
    console.error error.toString()
    throw error
