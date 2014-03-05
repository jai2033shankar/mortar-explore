#
# Copyright 2014 Mortar Data Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'rubygems'
require 'aws-sdk'
require 'explore/mortar/scraper/parse' 

module Cloud 
  class Browse
    include Parse

    attr_accessor :base_directory, :bucket, :object_key, :delim_char, :index

    def initialize(s3_path, delim_char = "\t")
      @bucket = s3_path[5, s3_path[5,s3_path.length()-1].index('/')]
      @base_directory = s3_path 
      @object_key = s3_path[s3_path.index(@bucket) + @bucket.length()+1, @base_directory.length()]
      @delim_char = delim_char 
      @index = 1
      # aws keys set from calling require_aws_keys
      ENV['AWS_ACCESS_KEY_ID'] = ENV["AWS_ACCESS_KEY"]
      ENV['AWS_SECRET_ACCESS_KEY'] = ENV["AWS_SECRET_KEY"]
    end

    def browse(quantity, start_index = @index, directory_or_file = nil)
      #obj = s3.buckets['cngan-dev/retail'].objects['key']
      bucket =  get_bucket
      if bucket != nil
        s3_obj = get_s3_object(bucket)
        return parse_results(get_content(s3_obj, quantity, start_index))
      else
        return {:error => "Specified bucket #{@bucket} does not exist."}
      end

    end


    def get_bucket
      s3 = AWS::S3.new
      if s3.buckets[@bucket].exists?
        return s3.buckets[@bucket]
      else
        return nil
      end
    end

    def get_s3_object(bucket)
      if bucket.objects[@object_key].exists?
        return bucket.objects[@object_key] 
      else
        #attempt to find item
        valid_items = Array.new
        bucket.objects.each do |obj|
          print obj
          if obj.key[@object_key.length+1, obj.key.to_s.length-1].index('/')
            valid_items.push(obj)
          end
        end
        if valid_items.length > 0
          return valid_items[0] 
        end
      end
      return nil
    end

    def get_content(s3_object, quantity, index)
      content = Array.new
      count = 1  
      str = "" 
      begin
        catch :break do
          s3_object.read do |chunk|
            chunk.to_s.split("\n").each do |line|
              if (count >= index)
                content.push(@object_key + ":" + count.to_s + ":" + line) 
                if count >= index + quantity-1
                  throw :break
                end
              end
              count = count + 1
            end
          end
        end
      rescue
      end
      return content

    end


    

  end
end
