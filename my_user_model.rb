require 'sqlite3'


class User
    def self.initialize
        @db = SQLite3::Database.new("sql.db")
        execute_sql_file("db.sql")
        create_table_if_not_exists
    end
    
    def self.execute_sql_file(filename)
        sql = File.read(filename)
        statements = sql.split(/;\n/)
        statements.each do |stmt|
          next if stmt.strip.empty?
          @db.execute(stmt)
        end
      end
      

    def self.create(user_info)
        #puts "Creating user with #{user_info}"        
        @db.execute(
            "INSERT INTO users(firstname, lastname, age, email, password) VALUES (?,?,?,?,?);",
            [user_info['firstname'], user_info['lastname'], user_info['age'], user_info['email'], user_info['password']]
        )
        user_id = @db.last_insert_row_id
        # get the inserted row as a hash
        result = @db.execute("SELECT * FROM users WHERE id = ?", user_id).first
        # return a new User object with the same attributes
        result ? result_to_user_object(result) : nil

    end

    def self.find(user_id)
        result = @db.execute("SELECT * FROM users WHERE id = ?", user_id).first
        result ? result_to_user_object(result) : nil
    end

    def self.all
        @db.execute("SELECT * FROM users").map {|result| result_to_user_object(result)}
    end

    def self.update(user_id, user_info)
        @db.execute("UPDATE users SET firstname = ?, lastname = ?, age = ?, email = ?, password = ?, WHERE user_id = ?", [firstname, lastename, age, email, password, user_id])
    end

    def self.destroy(user_id)
        @db.execute("DELETE FROM users WHERE id = ?", user_id)
    end

    private

    def self.create_table_if_not_exists
        @db.execute("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, firstname TEXT, 
            lastname TEXT, age INTEGER, email TEXT, password TEXT)")
    end

    def self.result_to_user_object(result)
        (id = result[0], firstname = result[1], lastname = result[2], age = result[3], email = result[4], password = result[5])
    end
end
User.initialize
User.create({firstname: "Thomas", lastname: "Anderson", age: 33, email: "neo@matrix.world", password: "matrix"})
#puts User.all
=begin  
user = User.new

user.create({firstname: "William", lastname: "Wall", age: 30, email: "willwall@gmail.com", password: "password"})

puts user.all
=end