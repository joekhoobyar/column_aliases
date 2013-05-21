require 'spec_helper'

describe ColumnAliases::Core do
  let(:person) { FactoryGirl.build(:person) }
    
  describe "#column_names" do
    subject { Person.column_names }
      
    it { should_not be_include('first_name') }
    it { should_not be_include('last_name') }
    it { should be_include('fname') }
    it { should be_include('lname') }
  end
  
  describe "#columns_hash" do
    subject { Person.columns_hash }
      
    it { should_not be_include('first_name') }
    it { should_not be_include('last_name') }
    it { should be_include('fname') }
    it { should be_include('lname') }
      
    it { subject['first_name'].should == subject['fname'] }
    it { subject['last_name'].should == subject['lname'] }
  end
end