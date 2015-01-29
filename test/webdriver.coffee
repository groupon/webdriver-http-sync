WebDriver = require '../lib'
instance = undefined

module.exports = ->
  return instance if instance?

  url = 'http://127.0.0.1:4444/wd/hub'
  capabilities = {
    browserName: 'phantomjs'
  }
  connectionOptions = {}

  return instance = new WebDriver(url, capabilities, connectionOptions)

