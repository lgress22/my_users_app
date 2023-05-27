require 'sinatra'
require 'json'
require 'sqlite3'
require_relative 'my_user_model'
require 'erb'
enable :sessions
set :port, 8080
set :bind, '0.0.0.0'
set :views, './views'
set :session_expire_after, nil
db = SQLite3::Database.new('sql.db')

#https://web-v8ace454d-ebe4.docode.us.qwasar.io/users/erb

get '/hello' do
    'Hello World!'
    #erb :index
  end
  
get '/users' do
    user_select = "SELECT firstname, lastname, email FROM users"
    @user = db.execute(user_select)
    @user.to_json
end  


post '/users' do
    db.execute("INSERT INTO users(firstname, lastname, age, email, password) 
    VALUES (?,?,?,?,?);", 
    [params[:firstname], params[:lastname], params[:age], params[:email], params[:password]])
    
    @user = {
    firstname: params[:firstname],
    lastname: params[:lastname],
    age: params[:age],
    email: params[:email]
  }

    @user.to_json
end

post '/sign_in' do
    email = params['email']
    password = params['password']
  
    user = User.all.find {|u| u[:email] == email}

    if user && user[:password] == password
        session[:user_id] = user[:id]
        user.delete(:password)
        json_object = JSON.generate(user)
        json_object
    else
        status 401
        'Invalid'
    end
    puts session.inspect
  end
  

  get '/home' do
    if session[:user_id]
        "Session Working and #{session[:user_id]} signed in"
    else
        "Session not working"
    end
end


put '/users' do
    @user_id = session[:user_id]
    @password = params['password']

    user = User.all.find {|u| u['id'] == @user_id}

    if user
        user[:password] = password
        user.delete(:password)
        json_object =  JSON.generate(user)
        json_object
    end

end

delete '/sign_out' do
    session.clear
    status 204

    if session.clear
        p "Session Successfully Cleared"
    end
end

delete '/users' do

end

get '/users/erb' do
    # content_type :json
    @users = User.all.map(&:to_hash)
    @users.to_json
    #puts @users.inspect
    erb :index 
end
  

# https://web-v8ace454d-ebe4.docode.us.qwasar.io/users/erb
