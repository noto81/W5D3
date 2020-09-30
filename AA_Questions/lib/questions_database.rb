require "singleton"
require "sqlite3"

class QuestionsDatabase < SQLite3::Database
    include Singleton
    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end 

class User
    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
        
        SELECT * FROM users WHERE users.id = ?

        SQL
        User.new(data.first)
    end

    def self.find_by_name(fname, lname)
        data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    
        SELECT * FROM users WHERE users.fname = ? AND users.lname = ?

        SQL
        
        User.new(data.first)
    end
    require "byebug"
    attr_reader :id
    attr_accessor  :fname, :lname
    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def create
        raise "#{self} already in database" if @id
        QuestionsDatabase.instance.execute(<<-SQL, fname, lname) 
        
        INSERT INTO
            users(fname, lname)
        VALUES
            (? , ?)
        SQL
        @id = QuestionsDatabase.instance.last_insert_row_id
    end

end

class Question
    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
        
        SELECT * FROM questions WHERE questions.id = ?

        SQL
        Question.new(data.first)
    end

    def self.find_by_author_id(author_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    
        SELECT * FROM questions WHERE questions.author_id = ?

        SQL
        
        data.map {|question| Question.new(question)} 
    end
    require "byebug"
    attr_reader :id
    attr_accessor  :title, :body, :author_id
    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def create
        raise "#{self} already in database" if @id
     #   debugger
        QuestionsDatabase.instance.execute(<<-SQL, title, body, author_id) 
        
        INSERT INTO
            questions(title, body, author_id)
        VALUES
            (?, ?, ?)
        SQL
        #debugger
        @id = QuestionsDatabase.instance.last_insert_row_id
    end
end

class QuestionFollow

end

class Reply

end

class QuestionLike

end