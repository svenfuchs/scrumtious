class Milestone < ActiveRecord::Base
  class << self
    def normalize_name!(name)
      name.gsub!(/(sprint|release)\s*/i, '') if name
      name
    end
    
    def find_every(options)
      normalize_name! options[:conditions][:name] if options[:conditions].is_a? Hash
      super
    end
  end
  
  def name=(name)
    write_attribute :name, self.class.normalize_name!(name)
  end
end