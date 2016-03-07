
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
var Element, NOT_FOUND_MESSAGE, assert, createElement, createElements, elementOrNull, http, inspect, json, parseElement, parseResponseData,
  slice = [].slice;

http = require('./http');

assert = require('assertive');

json = require('./json');

parseResponseData = require('./parse_response');

inspect = require('util').inspect;

NOT_FOUND_MESSAGE = new RegExp(['Unable to locate element', 'Unable to find element', 'no such element'].join('|'));

createElement = function(http, selector, root) {
  var response;
  response = http.post(root + "/element", {
    using: 'css selector',
    value: selector
  });
  return parseElement(http, parseResponseData(response).ELEMENT);
};

createElements = function(http, selector, root) {
  var element, elements, i, len, response, results;
  response = http.post(root + "/elements", {
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

module.exports = Element = (function() {
  function Element(http1, elementId1) {
    this.http = http1;
    this.elementId = elementId1;
    assert.truthy('new Element(http, elementId) - requires http', this.http);
    assert.truthy('new Element(http, elementId) - requires elementId', this.elementId);
    this.root = "/element/" + this.elementId;
  }

  Element.prototype.inspect = function() {
    return inspect(this.constructor.prototype);
  };

  Element.prototype.get = function(attribute) {
    var pathname, response;
    assert.truthy('get(attribute) - requires attribute', attribute);
    pathname = attribute === 'text' ? this.root + "/text" : this.root + "/attribute/" + attribute;
    response = this.http.get(pathname);
    return parseResponseData(response);
  };

  Element.prototype.getElement = function(selector) {
    return elementOrNull((function(_this) {
      return function() {
        return createElement(_this.http, selector, _this.root);
      };
    })(this));
  };

  Element.prototype.getElements = function(selector) {
    return createElements(this.http, selector, this.root);
  };

  Element.prototype.getLocation = function() {
    var response;
    response = this.http.get(this.root + "/location");
    return parseResponseData(response);
  };

  Element.prototype.getLocationInView = function() {
    var response;
    response = this.http.get(this.root + "/location_in_view");
    return parseResponseData(response);
  };

  Element.prototype.getSize = function() {
    var response;
    response = this.http.get(this.root + "/size");
    return parseResponseData(response);
  };

  Element.prototype.isVisible = function() {
    var data, ref, response;
    response = this.http.get(this.root + "/displayed");
    data = (ref = response.body) != null ? ref.toString() : void 0;
    return json.tryParse(data).value;
  };

  Element.prototype.click = function() {
    this.http.post(this.root + "/click");
  };

  Element.prototype.type = function() {
    var strings;
    strings = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    assert.truthy('type(strings) - requires strings', strings);
    this.http.post(this.root + "/value", {
      value: strings
    });
  };

  Element.prototype.clear = function() {
    this.http.post(this.root + "/clear");
  };

  return Element;

})();

elementOrNull = Element.elementOrNull = function(create) {
  var error, error1;
  try {
    return create();
  } catch (error1) {
    error = error1;
    if (NOT_FOUND_MESSAGE.test(error.toString())) {
      return null;
    }
    console.error(error.toString());
    throw error;
  }
};
