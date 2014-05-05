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
require 'sead_bag'
require 'rspec'

describe CrossWalk do
  it "takes the sead ore and produce a dspace metadata file" do
    f = File.new 'spec/fixtures/testore.xml'
    crosswalk = CrossWalk.new(f)
    crosswalk.transform
    crosswalk.dc.dc_root.xpath('//dcvalue[@element="creator"]').first.content.should == 'Quan Zhou'
  end
end

describe 'sead_bag' do

  it 'should get a list of files from the data directory' do
    bag = SeadBag.new("test-items")
    vals = YAML.load_file('spec/fixtures/test_vals.yml')
    bag.data_files.reject{|rf| rf=='.' || rf == '..'}.each {|f|
      vals["data_files"].should include(f)}
  end

  it 'should contain the contents of the ore file' do
    f = Dir.new "test-items"
    bag = SeadBag.new(f)
    bag.ore_file.document.xpath('//dcterms:creator/foaf:name').first.content.should=="Quan Zhou"
  end
end

describe 'DSpacePackage' do
  it 'should contain the file for one of the bag\'s aggregated items' do
    #before we do this we need an aggregated items class
      true.should == false
  end
end

describe OreXml do
  it 'should contain a top level aggregation id' do
    test_ore = OreXml.new(File.new 'spec/fixtures/testore.xml')
    test_ore.aggregation_id.should == "http://sead-test/fakeUri/0489a707-d428-4db4-8ce0-1ace548bc653_Aggregation"
  end
end

