# require File.dirname(__FILE__) + '/../spec_helper'
#
# Factory.define :project do |f|
#   f.releases  {|a| [a.association(:release)] }
# end
#
# Factory.define :release do |f|
#   # bad idea ... endless loop
#   # f.project {|a| a.association(:project)}
#
#   f.tickets {|a| [a.association(:ticket)]}
# end
#
# Factory.define :sprint do |f|
#   # hmm, now how could i define this?
#   # f.release {|a| a.project.releases.first }
# end
#
# Factory.define :ticket do |f|
#   # same here ...
#   # f.release {|a| a.sprint.releases }
#   f.versions {|a| [a.association(:version)] }
# end
#
# Factory.define :version, :class => Ticket::Version do |f|
# end
#
# describe 'Playing with factory_girl' do
#   before do
#     @project = Factory :project
#   end
#
#   it "should set project to project.releases.first.project" do
#     @project.should == @project.releases.first.project
#   end
# end

