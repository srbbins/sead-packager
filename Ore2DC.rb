#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'fileutils'
require 'nokogiri'
require 'pathname'
require_relative 'orexml'
require_relative 'dcxml'

f = File.new ARGV[0]
if ARGV.length == 2
  out = ARGV[1]
else 
  out = "dc.xml"
end

ore = OreXml.new(f)



dc = DCXml.new



puts dc.dc_root

class DCNode
  attr_accessor :element, :qualifier, :document, :node

  def initialize(document, element, qualifier)
    @document, @element, @qualifier = document, element, qualifier
    out_node = Nokogiri::XML::Node.new('dcvalue', document)
    out_node['element']= element
    @element = out_node['element']
    out_node['qualifier']= qualifier
    @qualifier = out_node['qualifier']
    @node = out_node
  end

  def content=(content_string)
    @node.content = content_string
  end

  def content
    @node.content
  end
end

ore.document.xpath("//dcterms:creator").each() do |node|
  puts node.content.to_s
  out_node = DCNode.new(dc.document, 'creator', 'none')
  name = node.xpath("foaf:name")[0].content
  out_node.content = name
  dc.dc_root << out_node.node
end

puts dc.document.to_s


