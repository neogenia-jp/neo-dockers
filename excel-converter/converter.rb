#!/usr/bin/ruby

require 'pathname'
require 'tempfile'
require 'libreconv'

class Converter
 def self.convert(input_file, output_file, convert_type='pdf')
  if File.directory? output_file
    output_dir = Pathname.new(output_file)
    output_file = output_dir + "#{File.basename(input_file, '.*')}.#{convert_type}"
  else
    output_dir = File.basename(output_file)
  end

  tmp_file = Tempfile.create('__', output_dir).path

  Libreconv.convert(input_file, tmp_file, nil, convert_type)

  File.rename(tmp_file, output_file)
 end
end
