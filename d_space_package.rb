require 'fileutils'

class DSpacePackage
  attr_accessor :content_filenames

  def initialize(content_filenames, metadata)
    @content_filenames, @metadata = content_filenames, metadata
  end

  def serialize(output_dir, bag_loc)
    out = File.open(File.join(output_dir, "metadata.xml"), "w")
    out.puts @metadata
    @content_filenames.each do |filename|
      full_path_to_file = File.join(bag_loc, filename)
      FileUtils.cp(full_path_to_file, output_dir)
    end
  end
end