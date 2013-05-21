require 'spec_helper'

describe ColumnAliases::Core do
  describe "::column_names" do
    subject { Person.column_names }

    it { should_not be_include('first_name') }
    it { should_not be_include('last_name') }
    it { should be_include('fname') }
    it { should be_include('lname') }
  end
  
  describe "::columns_hash" do
    subject { Person.columns_hash }

    it { should_not be_include('first_name') }
    it { should_not be_include('last_name') }
    it { should be_include('fname') }
    it { should be_include('lname') }

    describe "fetches columns by alias" do      
	    it { subject['first_name'].should == subject['fname'] }
	    it { subject['last_name'].should == subject['lname'] }
    end
  end
  
  shared_examples_for 'model initialization' do
    its(:fname) { should == 'John' }
    its(:lname) { should == 'Doe' }
    its(:first_name) { should == 'John' }
    its(:last_name) { should == 'Doe' }
  end
  
  describe '#initialize with aliased names' do
    subject { Person.new(:first_name=>'John',:last_name=>'Doe') }
    it_should_behave_like 'model initialization'
  end
  
  describe '#initialize without aliased names' do
    subject { Person.new(:fname=>'John',:lname=>'Doe') }
    it_should_behave_like 'model initialization'
  end
  
  describe 'attribute reading' do
    subject { FactoryGirl.build(:person) }
      
    its(:first_name) { should == 'John' }
    its(:fname) { should == 'John' }
    its(:last_name) { should == 'Doe' }
    its(:lname) { should == 'Doe' }
	      
	  describe '#read_attribute' do
	    it { subject.read_attribute(:first_name).should == 'John' }
	    it { subject.read_attribute('first_name').should == 'John' }
	    it { subject.read_attribute(:fname).should == 'John' }
	    it { subject.read_attribute('fname').should == 'John' }
	    it { subject.read_attribute(:last_name).should == 'Doe' }
	    it { subject.read_attribute('last_name').should == 'Doe' }
	    it { subject.read_attribute(:lname).should == 'Doe' }
	    it { subject.read_attribute('lname').should == 'Doe' }
	  end
	  
	  describe '#[]' do
	    it { subject[:first_name].should == 'John' }
	    it { subject['first_name'].should == 'John' }
	    it { subject[:fname].should == 'John' }
	    it { subject['fname'].should == 'John' }
	    it { subject[:last_name].should == 'Doe' }
	    it { subject['last_name'].should == 'Doe' }
	    it { subject[:lname].should == 'Doe' }
	    it { subject['lname'].should == 'Doe' }
	  end
  end
  
  describe 'attribute writing' do
    subject { FactoryGirl.build(:person) }
      
    after(:each) do
      subject.first_name.should == 'Johnny'
	    subject.fname.should == 'Johnny'
	    subject.last_name.should == 'Doey'
	    subject.lname.should == 'Doey'
    end
    
    describe 'with aliased names' do
      it 'works with attribute methods' do
        subject.first_name = 'Johnny'
        subject.last_name = 'Doey'
      end
      
      it 'works with #write_attribute(:name)' do
        subject.instance_eval{ write_attribute(:first_name, 'Johnny') }
        subject.instance_eval{ write_attribute(:last_name, 'Doey') }
      end
      
      it "works with #write_attribute('name')" do
        subject.instance_eval{ write_attribute('first_name', 'Johnny') }
        subject.instance_eval{ write_attribute('last_name', 'Doey') }
      end
      
      it 'works with #[:name]=' do
        subject[:first_name] = 'Johnny'
        subject[:last_name] = 'Doey'
      end
      
      it "works with #['name']=" do
        subject['first_name'] = 'Johnny'
        subject['last_name'] = 'Doey'
      end
    end
	      
    describe 'with unaliased names' do
      it 'works with attribute methods' do
        subject.fname = 'Johnny'
        subject.lname = 'Doey'
      end
      
      it 'works with #write_attribute(:name)' do
        subject.instance_eval{ write_attribute(:fname, 'Johnny') }
        subject.instance_eval{ write_attribute(:lname, 'Doey') }
      end
      
      it "works with #write_attribute('name')" do
        subject.instance_eval{ write_attribute('fname', 'Johnny') }
        subject.instance_eval{ write_attribute('lname', 'Doey') }
      end
      
      it 'works with #[:name]=' do
        subject[:fname] = 'Johnny'
        subject[:lname] = 'Doey'
      end
      
      it "works with #['name']=" do
        subject['fname'] = 'Johnny'
        subject['lname'] = 'Doey'
      end
    end
	      
  end
  
end