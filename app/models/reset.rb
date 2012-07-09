class Reset < ActiveRecord::Base
  attr_accessible :user_id, :reason
  belongs_to :user
  validates_presence_of :user_id

  after_create :deliver_notification

  private

  def deliver_notification
    UserMailer.reset_notification(self).deliver
  end
end
