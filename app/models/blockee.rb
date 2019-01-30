class Blockee < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :blockee_id, scope: :user_id
  
  def self.blockees_of_user(user)
    @blockee_users = []
    @blockees = user.blockees
    for blockee in @blockees
      blockee = User.find(blockee.blockee_id)
      @blockee_users.push blockee
    end
    return @blockee_users
  end
end
