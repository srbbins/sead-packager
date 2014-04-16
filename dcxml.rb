require 'fileutils'
require 'nokogiri'


class DCXml
  attr_accessor :document, :dc_root

  def initialize()
    @document = Nokogiri::XML('<?xml version="1.0" encoding ="utf-8" standalone="no"?>')
    @dc_root = out_document.create_element('dublin_core')
    @dc_root['schema']='dc'
    @document << @dc_root
  end
end