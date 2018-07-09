require('rspec')
require('pg')
require('list')
require('task')
require("spec_helper")
require('pry')

describe(List) do
  describe(".all") do
    it("starts off with no lists") do
      expect(List.all()).to(eq([]))
    end
  end

  describe("#name") do
    it("tells you its name") do
      list = List.new({:name => "Epicodus stuff", :id => nil})
      expect(list.name()).to(eq("Epicodus stuff"))
    end
  end

  describe("#id") do
    it("sets its ID when you save it") do
      list = List.new({:name => "Epicodus stuff", :id => nil})
      list.save()
      expect(list.id()).to(be_an_instance_of(Integer))
    end
  end

  describe("#save") do
    it("lets you save lists to the database") do
      list = List.new({:name => "Epicodus stuff", :id => nil})
      list.save()
      expect(List.all()).to(eq([list]))
    end
  end

  describe("#==") do
    it("is the same list if it has the same name") do
      list1 = List.new({:name => "Epicodus stuff", :id => nil})
      list2 = List.new({:name => "Epicodus stuff", :id => nil})
      expect(list1).to(eq(list2))
    end
  end
  describe("#list_all_tasks") do
    it("lists all the tasks involved in a given list_id") do
      my_list = List.new({:name => 'list1', :id => nil})
      my_list.save
      task1 = Task.new({:description => "Learn Thing 1", :list_id => my_list.id})
      task2 = Task.new({:description => "Learn Thing 2", :list_id => my_list.id})
      task1.save
      task2.save
      expect(my_list.list_all_tasks).to(eq([task1, task2]))
    end
  end
end
