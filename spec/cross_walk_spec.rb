$LOAD_PATH.unshift File.expand_path("../..", __FILE__)
require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'fileutils'
require 'nokogiri'
require 'pathname'
require 'd_space_cross_walk'
require 'dc_node'
require 'orexml'
require 'd_space_metadata'
require 'd_space_package'
require 'out_package_factory'
require 'dspace_package_factory'
require 'sead_bag'
require 'rspec'

#this might be going away
describe DSpaceCrossWalk do
  it "takes the sead ore and produce a dspace metadata file" do
    bag = SeadBag.new("test-items")
    crosswalk = DSpaceCrossWalk.new(bag.ore_file, bag.ore_file.aggregated_resources[0])
    crosswalk.transform
    crosswalk.dc.dc_root.xpath('//dcvalue[@element="creator"]').first.content.should == 'Quan Zhou'
  end
end

describe SeadBag do

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

describe DspacePackageFactory do
  before(:all) do
    @factory = OutPackageFactory.new('Dspace')
    @bag = SeadBag.new("test-items")
  end
  it 'should get the filenames for one of the bag\'s aggregated items' do
    packager = @factory.new_packager(@bag.ore_file)
    filenames = packager.get_filenames("http://sead-test/fakeUri/cce29a32-1cbb-4859-bf03-15ecc8db97bc")
    filenames[0].should == "data/Vortex_Mining.xlsx"
  end
end

describe DSpacePackage do
  before(:all) do
    @tmpdir = 'sead_packager_test_tmp'
    @factory = OutPackageFactory.new('Dspace')
    @bag = SeadBag.new("test-items")
    @bag_dir = @bag.bag_dir
    @packager = @factory.new_packager(@bag.ore_file)
    package_array=@packager.generate
    @package = package_array[0]
    setup_tmp_dir
  end


  def setup_tmp_dir
    FileUtils.mkdir(@tmpdir)
  end


  def remove_tmp_dir
    FileUtils.rm_r(@tmpdir)
    FileUtils.rmdir(@tmpdir)
  end
  it 'should contain the filenames for all of the bag\'s aggregated items' do
    @package.content_filenames.should include('data/Vortex_Mining.xlsx')
  end
  it 'should build the package in the specified directory' do

    @package.serialize(@tmpdir, @bag_dir)
    Dir.entries(@tmpdir).should include("metadata.xml")
    Dir.entries(@tmpdir).should include("Vortex_Mining.xlsx")
  end
  after(:all) do
    entries = Dir.entries(Dir.getwd)
    if entries.include? @tmpdir
      remove_tmp_dir
    end
  end
end

describe OreXml do
  it 'should contain a top level aggregation id' do
    test_ore = OreXml.new(File.new 'spec/fixtures/testore.xml')
    test_ore.aggregation_id.should == "http://sead-test/fakeUri/0489a707-d428-4db4-8ce0-1ace548bc653_Aggregation"
  end
  it 'should have a list of aggregated resource ids' do
    test_ore = OreXml.new(File.new 'spec/fixtures/testore.xml')
    test_ore.aggregated_resources[0].should == "http://sead-test/fakeUri/cce29a32-1cbb-4859-bf03-15ecc8db97bc"
  end
end


