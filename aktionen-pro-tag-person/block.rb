require 'blockspring'

block = lambda do |request, response|
  databaseQuery = "SELECT statistics.x AS Datum, statistics.y AS Anzahl, users.name AS Person FROM statistics INNER JOIN users ON users.id = statistics.user_id WHERE statistics.topic = '#{request.params['object'].downcase}_#{request.params['action']}' ORDER BY Datum ASC, Person ASC"

  databaseResponse = Blockspring.run(
    "query-postgres",
    { "db_query" => databaseQuery },
    { "api_key" => request.params['PG_API_KEY']})

  response.addOutput('results', databaseResponse['results'])
  response.end()
end

Blockspring.define(block)
