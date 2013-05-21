# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :person do
    fname "John"
    lname "Doe"
    
    initialize_with{ new(attributes) }
  end
end
