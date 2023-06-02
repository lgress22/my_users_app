require 'sqlite3'
require 'json'

class User
  def self.initialize
    db = SQLite3::Database.new("sql.db")
    execute_sql_file(db, "db.sql")
    create_table_if_not_exists(db)
  end

  def self.execute_sql_file(db, filename)
    sql = File.read(filename)
    statements = sql.split(/;\n/)
    statements.each do |stmt|
      next if stmt.strip.empty?
      db.execute(stmt)
    end
  end

  def self.create(user_info)
    db = SQLite3::Database.new("sql.db")
    db.execute(
      "INSERT INTO users(firstname, lastname, age, email, password) VALUES (?,?,?,?,?);",
      [user_info['firstname'], user_info['lastname'], user_info['age'], user_info['email'], user_info['password']]
    )
    user_id = db.last_insert_row_id
    result = db.execute("SELECT * FROM users WHERE id = ?", user_id).first
    if result
      user_object = result_to_user_object(result)
      json_object = JSON.generate(user_object)
      puts json_object # Print the JSON object
      user_object
    else
      nil
    end
  end
  

  def self.find(user_id)
    db = SQLite3::Database.new("sql.db")
    result = db.execute("SELECT * FROM users WHERE id = ?", user_id).first
    result ? result_to_user_object(result) : nil
  end

  def self.all
    db = SQLite3::Database.new("sql.db")
    db.execute("SELECT * FROM users").map { |result| result_to_user_object(result) }
  end

  def self.update(user_id, user_info)
    db = SQLite3::Database.new("sql.db")
    query = <<~SQL
      UPDATE users SET
        firstname = ?,
        lastname = ?,
        age = ?,
        email = ?,
        password = ?
      WHERE id = ?
    SQL
    db.execute(query, [
      user_info['firstname'],
      user_info['lastname'],
      user_info['age'],
      user_info['email'],
      user_info['password'],
      user_id
    ])

  end

  def self.destroy(user_id)
    db = SQLite3::Database.new("sql.db")
    db.execute("DELETE FROM users Where id = ?", user_id)
  end

  def self.destroy_all
    db = SQLite3::Database.new("sql.db")
    db.execute("DELETE FROM users")
  end
  private

  def self.create_table_if_not_exists(db)
    db.execute("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, firstname TEXT, 
        lastname TEXT, age INTEGER, email TEXT, password TEXT)")
  end

  def self.result_to_user_object(result)
    id, firstname, lastname, age, email, password = result
    { id: id, firstname: firstname, lastname: lastname, age: age, email: email, password: password }
  end
end
user_info = {
  'firstname' => 'John',
  'lastname' => 'Smith',
  'age' => 35,
  'email' => 'JohnSmith@gmail.com',
  'password' => 'John123'
}


User.initialize
#User.create(user_info)
#puts User.update(user_id, updated_info)
#User.destroy_all
 User.destroy(131)
 puts User.all
#puts User.find(94)
#User.update(131, 'John321')
