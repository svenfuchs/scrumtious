Scenario.define :two_users do
  @user_1 = User.create :remote_id => 1, :name => 'user_1'
  @user_2 = User.create :remote_id => 2, :name => 'user_2'
  
  @users = @user_1, @user_2
end