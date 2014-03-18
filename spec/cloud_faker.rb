class FakeBucket

  attr_accessor :bucket, :fake_object

  def initialize(bucket, fake_object = nil)
    @bucket = bucket
    @fake_object = fake_object
    if @fake_object != nil
      @fake_object.bucket = @bucket
    end
  end

  def exists?
    File.directory?(@bucket)
  end

  def objects
    if File.directory?(@fake_object.key)
      # TODO
    else

      return {@fake_object.key => @fake_object}
    end
  end
end


# Spec class to mock a fake s3 object
class FakeObject
  attr_accessor :key, :bucket, :dir

  def initialize(dir, key, bucket = '')
    @key = key
    @dir = dir
    @bucket = bucket 
  end

  def exists?
    # looks at the fake directory
    File.file?("#{@bucket}/#{@key}")
  end

  def read
    f = File.open("#{@bucket}/#{@key}")
    f.read
  end


end
