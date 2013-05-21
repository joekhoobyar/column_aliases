class Person < ActiveRecord::Base
  attr_protected :fname, :lname, :as=>:guest
  
  alias_column :first_name, :fname
  alias_column :last_name,  :lname
end
