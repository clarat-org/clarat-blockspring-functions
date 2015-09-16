require 'blockspring'

block = lambda do |request, response|
  databaseQuery = "SELECT COUNT(id) FROM #{request.params['object']}s"
  if request.params['state'] && !request.params['state'].empty?
    databaseQuery += " WHERE aasm_state = '#{request.params['state']}'"
  end

  databaseResponse = Blockspring.run(
    "query-postgres",
    { "db_query" => databaseQuery },
    { "api_key" => request.params['PG_API_KEY']})

  response.addOutput('count', databaseResponse['results'][1][0])
  response.end()
end

Blockspring.define(block)
