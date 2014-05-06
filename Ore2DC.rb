#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path("..", __FILE__)
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



f = File.new ARGV[0]
if ARGV.length == 2
  out = ARGV[1]
else 
  out = "dc.xml"
end


crosswalk = DSpaceCrossWalk.new(f)
crosswalk.transform


puts crosswalk.dc.document.to_s


