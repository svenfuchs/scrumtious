class User < ActiveRecord::Base
  has_many :activities, :order => "id DESC" do
    def current
      first
    end
  end
  
  def first_name
    @first_name ||= name.split(/ /)[0]
  end
end