class TeamcityStatusParser < StatusParser
  class << self
    def building(content, project)
      status_parser = self.new
      status_parser.building = false
      status_parser
    end
 
    def status(content)
      status_parser = self.new
      begin
        latest_build = Nokogiri::XML.parse(content).css('feed entry:first').first
        status_parser.success = (latest_build.at('author name').inner_text == 'Successful Build')
        status_parser.url = latest_build.at('link[rel=alternate]')['href']
        pub_date = Time.parse(latest_build.at('published').inner_text)
        status_parser.published_at = (pub_date == Time.at(0) ? Clock.now : pub_date).localtime
      rescue
      end
      status_parser
    end
  end
end