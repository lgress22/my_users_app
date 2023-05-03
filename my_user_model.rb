require 'sqlite3'

class User
    def initialize
        @db = SQLite3::Database.new("sql.db")
        execute_sql_file("db.sql")
        create_table_if_not_exists
    end
    
    def execute_sql_file(filename)
        sql = File.read(filename)
        statements = sql.split(/;\n/)
        statements.each {|stmt| @db.execute(stmt)}
    end

    def create(firstname, lastname, age, email, password)
        puts "Creating user with firstname: #{firstname}, lastname: #{lastname}, age: #{age}, email: #{email}, password: #{password}"
        
        @db.execute(
            "INSERT INTO users(firstname, lastname, age, email, password) VALUES (?,?,?,?,?)",
            [firstname, lastname, age, email, password]
        ) 
    end

    def find(user_id)
        result = @db.execute("SELECT * FROM users WHERE user_id = ?", user_id).first
        result ? result_to_user_object(result) : nil
    end

    def all
        @db.execute("SELECT * FROM users").map {|result| result_to_user_object(result)}
    end

    def update(user_id, firstname, lastname, age, email, password)
        @db.execute("UPDATE users SET firstname = ?, lastname = ?, age = ?, email = ?, password = ?, WHERE user_id = ?", [firstname, lastename, age, email, password, user_id])
    end

    def destroy(user_id)
        @db.execute("DELETE FROM users WHERE user_id = ?", user_id)
    end

    private

    def create_table_if_not_exists
        @db.execute("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, firstname TEXT, 
            lastname TEXT, age INTEGER, email TEXT, password TEXT)")
    end

    def result_to_user_object(result)
        {id: result[0], firstname: result[1], lastname: result[2], age: result[3], email: result[4], password: result[5]}
    end
end

  
  
user = User.new

user.create("John", "Doe", 30, "johndoe@gmail.com", "password1234")

puts user.all