# thx chris wanstrath, http://ozmm.org/posts/try.html

class Object
  ##
  #   @person ? @person.name : nil
  # vs
  #   @person.try(:name)
  def try(method, *args)
    send method, *args if respond_to? method
  end
end