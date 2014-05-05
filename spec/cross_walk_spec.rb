$LOAD_PATH.unshift File.expand_path("../..", __FILE__)
require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'fileutils'
require 'nokogiri'
require 'pathname'
require 'cross_walk'
require 'dc_node'
require 'orexml'
require 'dcxml'
require 'rspec'

describe CrossWalk do
  it "takes the sead ore and produce a dspace metadata file" do
    f = File.new '/home/srobbins/Projects/sead-packager/spec/fixtures/testore.xml'
    crosswalk = CrossWalk.new(f)
    crosswalk.transform
    crosswalk.dc.dc_root.xpath('//dcvalue[@element="creator"]').first.content.should == 'Quan Zhou'
  end
end