class Dog
    attr_accessor :name, :breed, :id

    def initialize(id: nil, name:, breed:)
        @id = id
        @name = name
        @breed = breed
    end

    def self.create_table
        DB[:conn].execute("CREATE TABLE dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT)")
    end 

    def self.drop_table
        DB[:conn].execute("DROP TABLE dogs")
    end

    def save
        DB[:conn].execute("INSERT INTO dogs (name, breed) VALUES (?, ?)", self.name, self.breed)
        self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")
        self
    end

    def self.create(hash)
        dog = Dog.new(hash)
        dog.save
    end

    def self.new_from_db(row)
        Dog.new(id: row[0], name: row[1], breed: row[2])
    end

    def self.find_by_id(id)
        dog = DB[:conn].execute("SELECT * FROM dogs WHERE id = ?", id)[0]
        Dog.new(id: id, name: dog[1], breed: dog[2])
    end

    def self.find_or_create_by(name:, breed:)
        match = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? and breed = ?", name, breed)
        if !match.empty? == 0
            Dog.create(name:name, breed:breed)
        else
            Dog.new_from_db(match[0])
        end
    end
    
    def self.find_by_name(name)
        dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ?", name)[0]
        Dog.new(id: dog[0], name: dog[1], breed: dog[2])
    end

    def update
        DB[:conn].execute("UPDATE dogs SET id=?, name=?, breed=?", self.id, self.name, self.breed)

    end
end