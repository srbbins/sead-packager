class MetadataAdapter
  Attr_reader :out_metadata

  def initialize(id, crosswalk, ore)
    @crosswalk, @ids, @ore  = crosswalk, ids, ore
    @out_metadata = transform
  end

  def tranform
     @crosswalk.transform
  end
end