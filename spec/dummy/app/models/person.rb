class Person < ActiveRecord::Base
  attr_accessible :fname, :lname
  
  alias_column :first_name, :fname
  alias_column :last_name,  :lname
end
