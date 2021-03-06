
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
var Element, createElement, createElements, elementOrNull, parseElement, parseResponseData;

parseResponseData = require('./parse_response');

elementOrNull = (Element = require('./element')).elementOrNull;

createElement = function(http, selector) {
  var response;
  response = http.post("/element", {
    using: 'css selector',
    value: selector
  });
  return parseElement(http, parseResponseData(response).ELEMENT);
};

createElements = function(http, selector) {
  var element, elements, i, len, response, results;
  response = http.post("/elements", {
    using: 'css selector',
    value: selector
  });
  elements = parseResponseData(response);
  results = [];
  for (i = 0, len = elements.length; i < len; i++) {
    element = elements[i];
    results.push(parseElement(http, element.ELEMENT));
  }
  return results;
};

parseElement = function(http, elementId) {
  if (elementId) {
    return new Element(http, elementId);
  } else {
    return null;
  }
};

module.exports = function(http) {
  return {
    getElement: function(selector) {
      return elementOrNull(function() {
        return createElement(http, selector);
      });
    },
    getElements: function(selector) {
      return createElements(http, selector);
    },
    setElementTimeout: function(ms) {
      http.post("/timeouts/implicit_wait", {
        ms: ms
      });
    }
  };
};
