require File.dirname(__FILE__) + '/../spec_helper'

describe Input do

  before(:each) do
    @attr = { 
      :name => 'power',
      :last_value => 252.4,
    }
  end

  it 'should create a new instance given a valid attribute' do
    Input.create!(@attr)
  end

  it { should belong_to :user }
end