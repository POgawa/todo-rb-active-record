require 'active_record'
require './lib/task'
require './lib/category'
require 'pry'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  system('clear')
  puts  "┻━┻︵ \(°□°)/ ︵ ┻━┻"
  puts "Ready to build your task list!"
  menu
end

def menu
  choice  = nil
  until choice == 'e'
    puts"Press 'a' to add tasks
    \nPress 'l' to list tasks or
    \nPress 'c' to list categories
    \nPress 'm' to mark task as done
    \nPress 'd' to delete a task
    \nPress 'e' to edit
    \nPress 'x' to exit"
    case gets.chomp.downcase
    when 'a'
      add_task
    when 'l'
      list_task
    when 'c'
      list_category
    when 'm'
      mark_task
    when 'd'
      delete_task
    when 'e'
      edit_task
    when 'x'
      puts 'Hasta manyana'
    else
      puts 'Invalid option choose again'
    end
  end
end

def add_task
  puts 'Please choose a category for your task or create a category a new one'
  list_category
  list = Category.new({:name => gets.chomp})
  puts "What task do you want to add?"
  task_add = gets.chomp
  list.tasks.new({:name => task_add, :done => false })
  list.save
  system ('clear')

  puts "Processing....."
  sleep(1)
  system ('clear')
  puts "Processing...."
  sleep(1)
  system ('clear')
  puts "Processing..."
  sleep(1)
  system ('clear')
  puts "Processing.."
  sleep(1)
  system ('clear')
  puts "Processing."
  sleep(1)
  system ('clear')
  puts "Processing"
  sleep(1)

  puts "#{list.tasks.first.name} has been saved to your To Do list."
end

def edit_task
  puts "Select task id you would like to edit"
  list_all
  choice = gets.chomp.to_i
  puts "Enter new task"
  new_name = gets.chomp
  Task.where({:id => choice}).each do |task|
    task.update({:name => new_name})
  end
  puts "\n"
  list_all
  puts "\n\n\n"
end


def list_all
  system('clear')
  puts "Here is the list of your tasks!"
    puts " =============================="
    Task.all.each do |task|
      if task.done == true
        puts "#{task.id}) #{task.name} = Task finished"
      else
        puts "#{task.id}) #{task.name} = Task not complete"
      end
    end
end

def list_task
  puts "Would you like to see all tasks, finished tasks or tasks you still need to do?"
  puts "  Press 'l' to list all tasks
  Press 'f' for finished tasks
  Press 'u' for unfinished tasks
  Press 'm' for main menu
  Press 'e' to edit task
  Press 't' to view task's category
  Press 'c' to list categories
  Press 'd' to delete task"
  case gets.chomp
  when 'l'
    list_all
    puts "\n\n\n\n\n\n"
    list_task

  when 'f'
    puts " =============================="
    Task.where({:done => true}).each { |task| puts task.name category.id}
    puts " =============================="
    list_task
  when 'u'
    puts " =============================="
    Task.where({:done => false}).each {|task| puts task.name category.id}
    puts " =============================="
    list_task
  when 'e'
    edit_task
  when 't'
    list_all
    puts "\nSelect task id you would like to see its category "
    task_id = gets.chomp.to_i
    cat = Task.find(task_id)
    puts "Task: #{cat.name} is in #{Category.find(cat.category_id).name} category"
      list_task
  when 'd'
    delete_task
  when 'c'
    list_category
  when 'm'
    menu
  else
  puts "Invalid entry!!"
  list_task
  end
end

def mark_task
  system('clear')
  puts "Enter number of task you like to mark done?"
  puts " =============================="
  Task.where({:done => false}).each {|task| p  task.id, task.name }
  puts " =============================="
  done_task_name = gets.chomp
  done_task = Task.where({:id => done_task_name}).first
  done_task.update({:done => true})
  puts "#{done_task.name} is now complete! Great job user! ʕ•ᴥ•ʔ\n\n"
end

def delete_task
  list_all
  puts 'What task id would you like to delete?'

  number = gets.chomp.to_i
  name = Task.where(:id => number).first.name

  if Task.where(:id => number).each {|task| task.destroy}
  else
      system('clear')
      puts "Entry not found. Try again!
      \n"
      delete_task
  end
  sleep(1)
  puts "#{name} has been deleted"
end

def list_category
  system 'clear'
  Category.all.each {|category| puts "#{category.id}) #{category.name}"}
  puts "Select a category id to see tasks"
  category = gets.chomp
  system 'clear'
  Task.where({:category_id => category}).each {|task| puts task.name}
  puts "\n\n\n\n\n\n
  Would you like to add or remove task from this category?
  Press 'a' to add task"
  case gets.chomp.downcase
  when 'a'
    binding.pry
    list = Category.find(category)
    puts "What task do you want to add to #{list.name} category?"
    task_add = gets.chomp
    list.tasks.new({:name => task_add, :done => false})
    list.save

  else
    'Invalid selection choose another'
  end





end
welcome
