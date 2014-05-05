require 'fileutils'
require 'nokogiri'


class OreXml
  attr_accessor :document

  def initialize(f)
    @document = Nokogiri::XML(f)
  end

end
