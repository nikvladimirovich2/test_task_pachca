require 'sinatra'
require 'mysql2'

set :bind, '0.0.0.0'
set :port, 4567

get '/' do
  db_config = {
    host: 'nginx-balancer', port: '80', username: 'root', database: 'app'
  }

  client = Mysql2::Client.new(db_config)
  client.query("INSERT INTO users (name) VALUES ('Test name')")
  results = client.query('SELECT * FROM users')

  content_type :json
  results.to_a.to_json
end
