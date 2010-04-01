class TeamcityStatusParser < StatusParser
  class << self
    def building(content, project)
      self.new
    end
 
    def status(content)
     self.new
    end

    def find(document, path)
    end
  end
end