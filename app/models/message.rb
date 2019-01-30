class Message < ActiveRecord::Base
	belongs_to :conversation
	belongs_to :user
	validates_presence_of :body, :conversation_id, :user_id
	def message_time
		Time.zone = 'Eastern Time (US & Canada)'
		created_at.strftime("%v at %l:%M %p")

	end
end