class TeamcityProject < Project
  def project_name
    name
  end

  def build_status_url
    return nil if feed_url.nil?

    url_components = URI.parse(feed_url)
    returning("#{url_components.scheme}://#{url_components.host}") do |url|
      url << ":#{url_components.port}" if url_components.port
      url << "/viewLog.html"
      url << "?#{url_components.query}" if url_components.query 
    end
  end

  def building_parser(content)
    TeamcityStatusParser.building(content, self)
  end

  def status_parser(content)
    TeamcityStatusParser.status(content)
  end
end