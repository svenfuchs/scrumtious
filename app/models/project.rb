class Project < ActiveRecord::Base
  has_many :components, :dependent => :destroy, :order => 'name'
  has_many :categories, :dependent => :destroy
  has_many :releases, :dependent => :destroy
  has_many :scheduled_days

  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  
  has_many :sprints, :dependent => :destroy do
    def unassigned
      find :all, :conditions => {:release_id => nil}
    end
  end
  
  has_many :tickets, :include => [:project, :release, :user], 
                     :order => 'milestones.name DESC, sprint_id DESC, tickets.state, tickets.priority, tickets.remote_id DESC, tickets.parent_id', 
                     :dependent => :destroy

  def synchronizer
    @synchronizer ||= Synchronizer.new self
  end
end