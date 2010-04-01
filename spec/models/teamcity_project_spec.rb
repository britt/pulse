require File.dirname(__FILE__) + '/../spec_helper'

describe TeamcityProject do
  before(:each) do
    @project = TeamcityProject.new(:name => "my_teamcity_project", :feed_url => "http://teamcity.example.com/feed.html?buildTypeId=bt35&itemsType=builds")
  end
  
  describe "#project_name" do
    it "should be the name" do
      @project.project_name.should == @project.name
    end
  end

  describe "status parsers" do
    it "should handle bad xml" do
      @project.status_parser('asdfa').should_not be_nil
      @project.building_parser('asdfas').should_not be_nil
    end
    
    it "should be for Hudson" do
      @project.status_parser('xml').should be_a(TeamcityStatusParser)
      @project.building_parser('xml').should be_a(TeamcityStatusParser)
    end
  end

  describe "#build_status_url" do
    it "should use viewLog.html" do
      @project.build_status_url.should == "http://teamcity.example.com:80/viewLog.html?buildTypeId=bt35&itemsType=builds"
    end
  end
end
