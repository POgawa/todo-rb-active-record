class Task < ActiveRecord::Base
  belongs_to(:categories)
end
