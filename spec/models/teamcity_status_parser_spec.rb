require File.dirname(__FILE__) + '/../spec_helper'
require 'nokogiri'

shared_examples_for "Teamcity status for a valid build history xml response" do
  it "should return the link to the checkin" do
    link = @response_doc.css("entry:first link").first.attribute('href').value
    @status_parser.url.should == link
  end

  it "should return the published date of the checkin" do
    date_elements =  @response_doc.css("entry:first published").first
    @status_parser.published_at.should == Time.parse(date_elements.content)
  end
end

describe TeamcityStatusParser do

  TC_HISTORY_SUCCESS_XML = File.read('test/fixtures/teamcity_status_examples/success.xml')
  TC_HISTORY_NEVER_GREEN_XML = File.read('test/fixtures/teamcity_status_examples/never_green.xml')
  TC_HISTORY_FAILURE_XML = File.read('test/fixtures/teamcity_status_examples/failure.xml')
  TC_HISTORY_INVALID_XML = "<foo><bar>baz</bar></foo>"

  describe "with reported success" do
    before(:all) do
      @response_doc = Nokogiri::XML.parse(TC_HISTORY_SUCCESS_XML)
      @status_parser = TeamcityStatusParser.status(TC_HISTORY_SUCCESS_XML)
    end

    it_should_behave_like "Teamcity status for a valid build history xml response"

    it "should report success" do
      @status_parser.should be_success
    end
  end

  describe "with reported failure" do
    before(:all) do
      @response_doc = Nokogiri::XML.parse(TC_HISTORY_FAILURE_XML)
      @status_parser = TeamcityStatusParser.status(TC_HISTORY_FAILURE_XML)
    end

    it_should_behave_like "Teamcity status for a valid build history xml response"

    it "should report failure" do
      @status_parser.should_not be_success
    end
  end

  describe "with invalid xml" do
    before(:all) do
      @parser = Nokogiri::XML.parse(@response_xml = TC_HISTORY_INVALID_XML)
      @response_doc = @parser.parse
      @status_parser = TeamcityStatusParser.status(TC_HISTORY_INVALID_XML)
    end
  end

  describe "building" do
    TC_BUILDING_XML = File.read('test/fixtures/building_status_examples/hudson_pulse_building.atom')
    TC_NOT_BUILDING_XML = File.read('test/fixtures/building_status_examples/hudson_pulse_not_building.atom')
    TC_BUILDING_INVALID_XML = "<foo><bar>baz</bar></foo>"

    # Unfortunately TeamCity does not expose what builds are running via RSS
    it "should always be false" do
      status_parser = TeamcityStatusParser.building(TC_BUILDING_XML, stub("a project", :project_name => 'Pulse'))
      status_parser.should_not be_building
    end

    # context "with a valid response that the project is building" do
    #      before(:each) do
    #        @status_parser = TeamcityStatusParser.building(TC_BUILDING_XML, stub("a project", :project_name => 'Pulse'))
    #      end
    # 
    #      it "should set the building flag on the project to true" do
    #        @status_parser.should_not be_building
    #      end
    #    end
    # 
    #    context "with a valid response that the project is not building" do
    #      before(:each) do
    #        @status_parser = TeamcityStatusParser.building(TC_NOT_BUILDING_XML, stub("a project", :project_name => 'Pulse'))
    #      end
    # 
    #      it "should set the building flag on the project to false" do
    #        @status_parser.should_not be_building
    #      end
    #    end
    # 
    #    context "with an invalid response" do
    #      before(:each) do
    #        @status_parser = TeamcityStatusParser.building(TC_BUILDING_INVALID_XML, stub("a project", :project_name => 'Socialitis'))
    #      end
    # 
    #      it "should set the building flag on the project to false" do
    #        @status_parser.should_not be_building
    #      end
    #    end
  end
end

