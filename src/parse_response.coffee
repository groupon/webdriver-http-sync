json = require './json'

module.exports = (response) ->
  data = response.body.toString()
  response = (json.tryParse data).value
  delete response.screen
  delete response.hCode # unhelpful selenium noise
  delete response.class # unhelpful selenium noise

  if response.message? && response.stackTrace?
    friendlyError = new Error response.message
    friendlyError.inner = response
    throw friendlyError

  response

