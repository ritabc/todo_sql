class List
  attr_reader(:name, :id)

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def self.all
    returned_lists = DB.exec("SELECT * FROM lists;")
    lists = []
    returned_lists.each() do |list|
      name = list.fetch("name")
      id = list.fetch("id").to_i()
      lists.push(List.new({:name => name, :id => id}))
    end
    lists
  end

  def save
    result = DB.exec("INSERT INTO lists (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def list_all_tasks
    returned_tasks_by_list = DB.exec("SELECT * FROM tasks WHERE list_id = (#{@id});")
    tasks = []
    returned_tasks_by_list.each() do |task|
      description = task.fetch("description")
      list_id = task.fetch("list_id").to_i() # The information comes out of the database as a string.
      due_date = task.fetch("due_date")
      tasks.push(Task.new({:description => description, :list_id => list_id, :due_date => due_date}))
    end
    tasks
  end

  def sort_tasks
    returned_tasks = DB.exec("SELECT * FROM tasks WHERE list_id =(#{@id}) ORDER BY due_date;")
    # tasks_by_list = self.list_all_tasks
    tasks_to_sort = []
    returned_tasks.each do |task|
      description = task.fetch("description")
      list_id = task.fetch("list_id").to_i
      due_date = task.fetch("due_date")
      tasks_to_sort.push(Task.new({:description => description, :list_id => list_id, :due_date => due_date}))
    end
    tasks_to_sort
  end

  def ==(another_list)
    self.name().==(another_list.name()).&(self.id().==(another_list.id()))
  end

  def self.find(id)
    found_list = nil
    List.all.each do |list|
      if list.id.==(id)
        found_list = list
      end
    end
    found_list
  end
end
