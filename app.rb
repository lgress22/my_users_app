require 'sinatra'
require 'json'
require 'sqlite3'
require_relative 'my_user_model'
require 'erb'
enable (:sessions)
set :port, 8080
set :bind, '0.0.0.0'
set :views, './views'
db = SQLite3::Database.new('sql.db')
#https://web-v8ace454d-ebe4.docode.us.qwasar.io/users
get '/hello' do
    'Hello World!'
    #erb :index
  end
  
get '/users' do
    # content_type :json
    @users = User.all.map(&:to_hash)
    @users.to_json
    #puts @users.inspect
    erb :index 
end


post '/users' do
    db.execute("INSERT INTO users(firstname, lastname, age, email, password) VALUES (?,?,?,?,?);", [params[:firstname], params[:lastname], params[:age], params[:email], params[:password]])
end

post '/sign_in' do

end

put '/users' do

end

delete '/sign_out' do

end

delete '/users' do

end

get '/users/erb' do
    users = User.all
    json_data = JSON.generate(users)
    content_type :json
    json_data
end
  

# https://web-v8ace454d-ebe4.docode.us.qwasar.io/users/erb
