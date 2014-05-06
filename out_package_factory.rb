class OutPackageFactory
  def initialize(format)
    @packager_class = self.class.const_get("#{format}PackageFactory")
  end

  def new_packager(ore)
    @packager_class.new(ore)
  end

end