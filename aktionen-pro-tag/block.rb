require 'blockspring'

block = lambda do |request, response|
  databaseQuery = "SELECT x AS Datum, SUM(y) AS Anzahl FROM statistics WHERE topic = '#{request.params['object'].downcase}_#{request.params['action']}' GROUP BY Datum ORDER BY Datum ASC"
  # if request.params['state'] && !request.params['state'].empty?
  #   databaseQuery += " WHERE aasm_state = '#{request.params['state']}'"
  # end

  databaseResponse = Blockspring.run(
    "query-postgres",
    { "db_query" => databaseQuery },
    { "api_key" => request.params['PG_API_KEY']})

  response.addOutput('results', databaseResponse['results'])
  response.end()
end

Blockspring.define(block)
