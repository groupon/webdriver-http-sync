{execFile} = require 'child_process'
path = require 'path'

assert = require 'assertive'

WebDriver = require '../'

phantomPort = 4499
phantomUrl = "http://127.0.0.1:#{phantomPort}"

webPort = 4497
webUrl = "http://127.0.0.1:#{webPort}/"
webTitle = 'A title'
testServer = path.join __dirname, 'test-server'

describe 'Webdriver', ->
  before 'example website', (done) ->
    @server = execFile testServer, [ '' + webPort ]
    @server.stderr.pipe process.stderr
    setTimeout done, 200

  before 'boot phantomjs', (done) ->
    phantomArgs = [ "--webdriver=#{phantomPort}" ]
    @phantom = execFile 'phantomjs', phantomArgs
    phantomOut = ''
    @phantom.on 'error', done

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
    }

  after 'close session', ->
    @driver?.close()

  after 'tear down phantom', ->
    try @phantom?.kill()

  after 'tear down test-server', ->
    try @server?.kill()

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
