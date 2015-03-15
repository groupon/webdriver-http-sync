{execFile} = require 'child_process'
path = require 'path'

assert = require 'assertive'

request = require('../lib/request')()

webPort = 4495
webUrl = "http://127.0.0.1:#{webPort}/json"
testServer = path.join __dirname, 'test-server'

describe 'request', ->
  before 'example website', (done) ->
    @server = execFile testServer, [ '' + webPort ]
    @server.stderr.pipe process.stderr
    setTimeout done, 200

  after 'tear down test-server', ->
    try @server?.kill()

  it 'sends a GET request', ->
    res = request webUrl
    data = JSON.parse res.body
    assert.equal '/json', data.url
    assert.equal 'GET', data.method
    assert.equal 'application/json', data.headers['content-type']

  it 'sends a POST request', ->
    res = request webUrl, 'POST', { x: { y: 42 } }
    data = JSON.parse res.body
    assert.equal '/json', data.url
    assert.equal 'POST', data.method
    assert.deepEqual '{"x":{"y":42}}', data.body
