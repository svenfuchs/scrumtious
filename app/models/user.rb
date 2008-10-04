class User < ActiveRecord::Base
  class << self
    def sync_from_remote_user!(remote_user)
      user = find_or_initialize_by_remote_id remote_user.id
      user.name = remote_user.name
      user.save!
    end
  end
  
  def first_name
    @first_name ||= name.split(/ /)[0]
  end
end