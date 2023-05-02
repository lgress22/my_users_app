require 'sqlite3'

class User
    attr_accessor :firstname, :lastname, :age, :email, :password

    def initialize(attributes = {})
        @firstname = attributes[:firstname]
        @lastname = attributes[:lastname]
        @age = attributes[:age]
        @email = attributes[:email]
        @password = attributes[:password]
      end
    
    
    def self.create
    db = SQLite3::Database.new('db.sql')
    db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS user_info(
            id INTEGER PRIMARY KEY,
            firstname TEXT,
            lastname TEXT,
            age INTEGER,
            email TEXT,
            password TEXT
        );
        SQL
        db.close
    end

    def save
        db = SQLite3::Database.new('db.sql')
        db.execute("INSERT INTO user_info(firstname, lastname, age, email, password) VALUES (?,?,?,?,?)",
            [firstname, lastname, age, email, password])
        db.close
    end

    def self.all
        db = SQLite3::Database.new('db.sql')
        rows = db.execute("SELECT * FROM user_info")
        db.close
        rows
    end
  end
  
  
  User.create
  
  @user = User.new(
    firstname: "John",
    lastname: "Smith",
    age: 30,
    email: "johnsmith@gmail.com",
    password: "password1234"
  )

#lastest_user = User.all.last
#puts lastest_user.join("\t")
=begin
user = User.new("John", "Doe", 34, "johnsmith@hotmail.com", "password456")
user.create




puts user.firstname
puts user.lastname
puts user.age
puts user.email
puts user.password

def initialize(firstname, lastname, age, email, password)
      @firstname = firstname
      @lastname = lastname
      @age = age
      @email = email
      @password = password
    end
=end
