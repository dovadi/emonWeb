require File.dirname(__FILE__) + '/../spec_helper'

describe User do

  VALID_TOKEN = '4sAysjRjznRKCmcyxqzj'

  before(:each) do
    @attr = { 
      :email => 'user@example.com',
      :password => 'foobar',
      :password_confirmation => 'foobar',
      :time_zone => 'Amsterdam'
    }
  end

  it 'should create a new instance given a valid attribute' do
    User.create!(@attr)
  end

  it { should have_many(:inputs).dependent(:destroy) }
  it { should have_many(:feeds).dependent(:destroy) }
  it { should have_many(:resets).dependent(:destroy) }

  it 'should require an email address' do
    no_email_user = User.new(@attr.merge(:email => ''))
    no_email_user.should_not be_valid
  end
  
  it 'should accept valid email addresses' do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it 'should reject invalid email addresses' do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it 'should reject duplicate email addresses' do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it 'should reject email addresses identical up to case' do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe 'passwords' do

    before(:each) do
      @user = User.new(@attr)
    end

    it 'should have a password attribute' do
      @user.should respond_to(:password)
    end

    it 'should have a password confirmation attribute' do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe 'password validations' do

    it 'should require a password' do
      User.new(@attr.merge(:password => '', :password_confirmation => '')).
        should_not be_valid
    end

    it 'should require a matching password confirmation' do
      User.new(@attr.merge(:password_confirmation => 'invalid')).
        should_not be_valid
    end

    it 'should reject short passwords' do
      short = 'a' * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

  end

  describe 'password encryption' do

    before(:each) do
      @user = User.create!(@attr)
    end

    it 'should have an encrypted password attribute' do
      @user.should respond_to(:encrypted_password)
    end

    it 'should set the encrypted password attribute' do
      @user.encrypted_password.should_not be_blank
    end

  end

  describe 'Admin' do

    before(:each) do
      @user = User.create!(@attr)
    end

    it 'should tell if the user is an admin' do
      @user.update_column(:admin, true)
      @user.admin?.should == true 
    end

  end

  describe 'Extra attributes' do

    before(:each) do
      @user = User.create!(@attr)
    end

    it 'should store its ip_address' do
      @user.ip_address = '127.0.0.1'
      @user.save.should == true 
    end

    it 'should store a serial number' do
      @user.serial_number = 'ABCD01234'
      @user.save.should == true 
    end

  end
  
  describe 'Api read token' do

    before(:each) do
      @user = User.create!(@attr)
    end

    it 'should create a new API read token' do
      @user.expects(:friendly_token).returns(VALID_TOKEN)
      @user.reset_api_read_token!
      @user.reload
      @user.api_read_token.should == VALID_TOKEN 
    end
  end

end