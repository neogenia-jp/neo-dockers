#!/usr/bin/ruby

def error(msg)
  STDERR.puts msg
  exit 1
end

if ARGV.length < 2
  error "Usage: #{File.basename $0} <input_file> <OUTPUT_FILE or DIR> [type]"
end

input_file=ARGV[0]
output_path=ARGV[1]
type=ARGV[2]||'pdf'

unless File.exist? input_file
  error "INPUT FILE #{input_file} is not exists!"
end

unless File.readable? input_file
  error "INPUT FILE #{input_file} is not readable!"
end

puts "INPUT_FROM: #{input_file}"
puts "OUTPUT_TO: #{output_path}"
print "Converting to #{type}... "

require_relative 'converter'
Converter.convert(input_file, output_path, type)

puts "OK"
