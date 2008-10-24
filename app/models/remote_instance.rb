class RemoteInstance < ActiveRecord::Base
  belongs_to :local, :polymorphic => true
  belongs_to :project
end