require 'sinatra'
require 'json'
require 'sqlite3'
require_relative 'my_user_model'
require 'erb'
enable :sessions
set :port, 8080
set :bind, '0.0.0.0'
set :views, './views'
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
        # user.delete(:lastname)
        # user.delete(:age)
        json_object = JSON.generate(user)
        json_object
        #return session[:user_id]
        #redirect '/home'
    else
        status 401
        'Invalid'
    end
  end


  get '/home' do
    if session[:user_id]
        "Session Working and #{session[:user_id]} signed in"
    else
        "Session not working"
    end
end


put '/users' do
    user_id = session[:user_id]
    user_info = {
    'firstname' => params['firstname'],
    'lastname' => params['lastname'],
    'age' => params['age'],
    'email' => params['email'],
    'password' => params['password']
  }
  
    if user_id
      User.update(user_id, user_info)
      @user = User.find(user_id)
      json_object = JSON.generate(@user)
      status 200
      json_object
    else
      status 400
      'Password did not update'
    end
  end
  

delete '/sign_out' do
    session.clear
    status 204
    'Session Cleared'
  end
  

delete '/users' do
    user_id = session[:user_id]
    session.clear
    status 204
    user_destroy = User.destroy(user_id)

    if session.clear
        user = User.find(user_id)
        if user
          user_destroy
          puts "USER IS DELETED"
        else
          puts "User not found"
        end
      else
        puts "No user associated with the session"
      end
    
end

get '/users/erb' do
    # content_type :json
    @users = User.all.map(&:to_hash)
    @users.to_json
    #puts @users.inspect
    erb :index 
end


get '/test' do
    "value = " << session[:value].inspect
end

get '/:value' do
    session['value'] = params['value']
end

  

# https://web-v8ace454d-ebe4.docode.us.qwasar.io/users/erb
