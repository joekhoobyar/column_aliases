require 'spec_helper'

shared_examples_for 'a list of column names' do
  it 'has unchanged contents' do
    should_not be_include('first_name')
    should_not be_include('last_name')
    should be_include('fname')
    should be_include('lname')
  end
end

shared_examples_for 'a person named' do |fname,lname|
  its(:fname) { should == fname }
  its(:lname) { should == lname }
  its(:first_name) { should == fname }
  its(:last_name) { should == lname }
end

shared_examples_for 'a readable attribute' do |aliased,unaliased,value|
  its([aliased.to_s]) { should == value }
  its([unaliased.to_s]) { should == value }
  its([aliased.to_sym]) { should == value }
  its([unaliased.to_sym]) { should == value }
end

shared_examples_for 'a writable attribute' do |aliased,unaliased,value|
  after(:each) do
    subject[aliased].should == value
    subject[unaliased].should == value
  end

  it('can be written by aliased name') { writer.call aliased.to_s, value }
  it('can be written by unaliased name') { writer.call unaliased.to_s, value }
  it('can be written by aliased symbol') { writer.call aliased.to_sym, value }
  it('can be written by unaliased symbol') { writer.call unaliased.to_sym, value }
end

describe ColumnAliases::Core::ClassMethods do

  describe "::column_names" do
    subject { Person.column_names }
    it_behaves_like 'a list of column names'
  end

  describe "::columns_hash" do
    subject { Person.columns_hash }

    describe '#keys' do
      subject { Person.columns_hash.keys }
      it_behaves_like 'a list of column names'
    end

    it "can be indexed by alias" do
      subject['first_name'].should == subject['fname']
      subject['last_name'].should == subject['lname']
    end
  end
end

describe ColumnAliases::Core do
  subject { FactoryGirl.build(:person) }

  describe '#initialize with aliased names' do
    subject { Person.new(:first_name=>'John',:last_name=>'Doe') }
    it_behaves_like 'a person named', 'John', 'Doe'
  end

  describe '#initialize with unaliased names' do
    subject { Person.new(:fname=>'John',:lname=>'Doe') }
    it_behaves_like 'a person named', 'John', 'Doe'
  end

  describe '#attributes= with aliased names' do
    before(:each) { subject.attributes = {:first_name=>'John',:last_name=>'Doe'} }
    it_behaves_like 'a person named', 'John', 'Doe'
  end

  describe '#attributes= with unaliased names' do
    before(:each) { subject.attributes = {:fname=>'John',:lname=>'Doe'} }
    it_behaves_like 'a person named', 'John', 'Doe'
  end

  describe '#read_attribute' do
    subject { proc{|k| FactoryGirl.build(:person).read_attribute(k) } }
    it_behaves_like 'a readable attribute', :first_name, :fname, 'John'
    it_behaves_like 'a readable attribute', :last_name, :lname, 'Doe'
  end

  describe '#[]' do
    it_behaves_like 'a readable attribute', :first_name, :fname, 'John'
    it_behaves_like 'a readable attribute', :last_name, :lname, 'Doe'
  end

  describe '#{attr_name}=' do
    let(:writer) { proc{|k,v| subject.send(:"#{k}=", v) } }
    it_behaves_like 'a writable attribute', :first_name, :fname, 'Jane'
    it_behaves_like 'a writable attribute', :last_name, :lname, 'Smith'
  end

  describe '#write_attribute()' do
    let(:writer) { proc{|k,v| subject.instance_eval{ write_attribute(k, v) } } }
    it_behaves_like 'a writable attribute', :first_name, :fname, 'Jane'
    it_behaves_like 'a writable attribute', :last_name, :lname, 'Smith'
  end

  describe '#[]=' do
    let(:writer) { proc{|k,v| subject[k] = v } }
    it_behaves_like 'a writable attribute', :first_name, :fname, 'Jane'
    it_behaves_like 'a writable attribute', :last_name, :lname, 'Smith'
  end

end
