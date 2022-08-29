class Dog
    attr_accessor :name, :breed, :id
      def initialize(name:,breed:,id: nil)
          @name = name
          @breed = breed
          @id = id
      end
#create a new instance
    def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT)
        SQL
        DB[:conn].execute(sql)
    end  
#drops the table from the database
    def self.drop_table
      sql = <<-SQL
      DROP TABLE IF EXISTS dogs 
      SQL
      DB[:conn].execute(sql)
    END
#save the table 
# inserts the new record into the database
# returns the instance
    def save
        sql = <<-SQL
          INSERT INTO dogs (name, breed)
          VALUES (? , ?)
        SQL
        DB[:conn].execute(sql, self.name, self.breed)

        self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
        self
    END
# CREATES A NEW ROW 
    def self.create(name:, breed:)
#RETURN AN INSTANCE OF THE Dod class
        dog = Dog.new(name: name, breed: breed)
        dog.save
    end
#  return an array representing a dog's data
    def self.new_from_db(row)
# self.new is equivalent to Dog.new
      self.new(id: row[0], name: row[1], breed: row[2])
    end
# return an array of Dog instances for every record in the dogs table.
    def self.all
      sql = <<-SQL
        SELECT * FROM dogs
      SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end
#this method will first insert a dog into the database and then attempt to find it by calling the find_by_name method
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM dogs
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
#   class method takes in an ID, and should return a single Dog instance for the corresponding record in the dogs
    def self.find(id)
        sql = <<-SQL
        SELECT * FROM dogs WHERE id = ? 
            LIMIT 1
            SQL
            
    DB[:conn].execute(sql, id).map do |row|
        self.new_from_db(row)
      end.first
    end

end