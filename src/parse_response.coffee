json = require './json'

cleanResponse = (response) ->
  delete response.screen
  delete response.hCode # unhelpful selenium noise
  delete response.class # unhelpful selenium noise

validateResponse = (response) ->
  return if !response.message? || !response.stackTrace?

  friendlyError = new Error response.message
  friendlyError.inner = response
  throw friendlyError

module.exports = (response) ->
  return null if response.body == ''

  data = response.body.toString()
  response = (json.tryParse data).value

  if response?
    cleanResponse(response)
    validateResponse(response)

  response

