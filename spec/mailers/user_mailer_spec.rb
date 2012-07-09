require File.dirname(__FILE__) + '/../spec_helper'

describe UserMailer do

  describe 'Reset notification' do

    before(:each) do
      @user  = User.create!(:email => 'user@example.com', :password => 'foobar', :password_confirmation => 'foobar')
      @reset = @user.resets.create!(:reason => 'UNK')
      @email = UserMailer.reset_notification(@reset).deliver
    end

    it 'should be sent to the corresponding user' do
      @email.to.should == ['user@example.com']
    end

    it 'should have the correct subject' do
      @email.subject.should == 'Nanode reset notification!'
    end

    it 'should be sent from the noreply address' do
      @email.from.should == "noreply@#{HOST}"
    end

    it 'should have the correct time of the reset' do
      @email.should have_body_text("Time: #{@reset.created_at}")
    end

    it 'should have the correct reason of the reset' do
      @email.should have_body_text("Reason: #{@reset.reason}")
    end
  end

end
