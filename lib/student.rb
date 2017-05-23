require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
    row = DB[:conn].execute(sql)
    row.map do |student_data|
      self.new_from_db(student_data)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = "SELECT *
       FROM students
       WHERE name = ?
       LIMIT 1"
    student = DB[:conn].execute(sql, name)
    student.map do |student_data|
      self.new_from_db(student_data)
    end.first
  end

  def self.count_all_students_in_grade_9
    grade = 9
    sql = "SELECT *
      FROM students
      WHERE GRADE = ?"
    students_by_grade = DB[:conn].execute(sql, grade)
    students_by_grade.map do |student_data|
      self.new_from_db(student_data)
    end
  end

  def self.students_below_12th_grade
    grade = 12
    sql = "SELECT *
    FROM students
    WHERE GRADE != ?"
    students_by_grade = DB[:conn].execute(sql, grade)
    students_by_grade.map do |student_data|
      self.new_from_db(student_data)
    end
  end

  def self.first_student_in_grade_10
    sql = "SELECT *
          FROM students
          WHERE grade = 10
          LIMIT 1"
    students_grade_ten = DB[:conn].execute(sql)
    students_grade_ten.map do |student_data|
      self.new_from_db(student_data)
    end.first
  end

  def self.all_students_in_grade_x(x)
    sql = "SELECT *
          FROM students
          WHERE grade = ?"
    students_grade_x = DB[:conn].execute(sql, x)
    students_grade_x.map do |student_data|
    self.new_from_db(student_data)
    end
  end

  def self.first_x_students_in_grade_10(x)
    sql = "SELECT *
          FROM students
          WHERE grade = 10
          LIMIT ?"
    x_students = DB[:conn].execute(sql, x)
    x_students.map do |student_data|
      self.new_from_db(student_data)
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
