{execFile} = require 'child_process'
path = require 'path'

assert = require 'assertive'

WebDriver = require '../'

phantomPort = 4499
phantomUrl = "http://127.0.0.1:#{phantomPort}"

webPort = 4497
webUrl = "http://127.0.0.1:#{webPort}/"
timeoutUrl = "#{webUrl}timeout"
webTitle = 'A title'
testServer = path.join __dirname, 'test-server'

DEBUG = false

describe 'Webdriver', ->
  before 'example website', (done) ->
    @server = execFile testServer, [ '' + webPort ]
    @server.stderr.pipe process.stderr
    @server.stdout.pipe process.stdout if DEBUG
    setTimeout done, 200

  before 'boot phantomjs', (done) ->
    phantomArgs = [ "--webdriver=#{phantomPort}" ]
    @phantom = execFile 'phantomjs', phantomArgs
    phantomOut = ''
    @phantom.on 'error', done
    @phantom.stdout.pipe process.stdout if DEBUG
    @phantom.stderr.pipe process.stderr if DEBUG

    waitForBoot = (chunk) =>
      phantomOut += chunk.toString 'utf8'
      if -1 != phantomOut.indexOf "running on port #{phantomPort}"
        phantomOut = ''
        @phantom.stdout.removeListener 'data', waitForBoot
        done()

    @phantom.stdout.on 'data', waitForBoot

  before 'create driver', ->
    @driver = new WebDriver "#{phantomUrl}", {
      browserName: 'phantomjs'
    },{
      timeout: 1000
    }

  after 'close session', ->
    @driver?.close()

  after 'tear down phantom', ->
    try @phantom?.kill()

  after 'tear down test-server', ->
    try @server?.kill()

  describe 'at timeout url', ->
    it 'throws an error when a request times out', ->
      error = assert.throws => @driver.navigateTo timeoutUrl
      assert.include /Request connection timed out/, error.message

  describe 'at working url', ->
    before 'navigate to a page', ->
      @driver.navigateTo webUrl

    it 'can get the page title', ->
      assert.equal webTitle, @driver.getPageTitle()

    it 'can get the url', ->
      assert.equal webUrl, @driver.getUrl()

    describe 'unicode support', ->
      multibyteText = "日本語 text"

      it 'supports reading unicode input values', ->
        element = @driver.getElement '#unicode-input'
        result = element.get('value')
        assert.equal multibyteText, result

      it 'supports setting unicode input values', ->
        element = @driver.getElement '#blank-input'
        element.type multibyteText
        result = element.get('value')
        assert.equal multibyteText, result
