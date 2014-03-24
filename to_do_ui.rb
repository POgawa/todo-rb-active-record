require 'active_record'
require './lib/task'
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
    \nPress 'm' to mark task as done
    \nPress 'd' to delete a task
    \nPress 'e' to Exit"
    case gets.chomp.downcase
    when 'a'
      add_task
    when 'l'
      list_task
    when 'm'
      mark_task
    when 'd'
      delete_task
    when 'e'
      puts 'Hasta manyana'
    else
      puts 'Invalid option choose again'
    end
  end
end

def add_task
  puts 'What task do you want to add?'
  task_add = gets.chomp
  task = Task.new({:name => task_add, :done => false })
  task.save
  puts "Processing....."
  sleep(1)
  puts "#{task.name} has been saved to your To Do list."
end

def list_all
  puts "Here is the list of your tasks!"
    puts " =============================="
    Task.all.each do |task|
      if task.done == true
        puts "#{task.name} = Task finished"
      else
        puts "#{task.name} = Task not complete"
      end
    end
end

def list_task
  puts "Would you like to see all tasks, finished tasks or tasks you still need to do?"
  puts "  Press 'l' to list all tasks
  Press 'f' for finished tasks
  Press 'u' for unfinished tasks
  Press 'm' for main menu"
  case gets.chomp
  when 'l'
    list_all
    list_task
  when 'f'
    puts " =============================="
    Task.where({:done => true}).each { |task| puts task.name}
    puts " =============================="
    list_task
  when 'u'
    puts " =============================="
    Task.where({:done => false}).each {|task| puts task.name}
    puts " =============================="
    list_task
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
  puts 'What task would you like to delete?'

  choice = gets.chomp

  Task.all.each do |task|

    if task.name.include?(choice)
      task.destroy
      menu
    else
      system('clear')
      puts "Entry not found. Try again! \n"
      delete_task
    end
  end
  sleep(1)
  puts "#{choice} has been deleted"
  menu
end
welcome
