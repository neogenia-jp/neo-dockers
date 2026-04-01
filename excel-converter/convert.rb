#!/usr/bin/ruby

require 'socket'
require 'tempfile'
require_relative 'converter'

LISTEN_PORT = (ENV['LISTEN_PORT'] || 2222).to_i
TYPE = (ENV['TYPE'] || 'pdf').freeze

def log(msg)
  $stdout.puts "[PID:#{$$}] #{msg}"
end

def write_tempfile(data)
  Tempfile.create(['excel_in', ''], '/tmp') do |f|
    f.binmode
    f.write(data)
    f.flush
    f.close
    yield f.path
  end
end

def convert_and_send(client, input_path)
  output_file = File.join('/tmp', "#{File.basename(input_path, '.*')}.#{TYPE}")

  log "INPUT_FROM: #{input_path}"
  log "OUTPUT_TO: #{output_file}"
  log "Converting to #{TYPE}..."

  Converter.convert(input_path, output_file, TYPE)

  output_size = File.size(output_file)
  log "OK (#{output_size} bytes), sending result..."
  client.write(File.binread(output_file))
  log "Done"
ensure
  File.delete(output_file) if File.exist?(output_file)
end

def handle_client(client)
  remote = begin; client.peeraddr[3]; rescue; 'unknown'; end
  log "Connection accepted from #{remote}"

  data = client.read
  log "Received #{data.bytesize} bytes from #{remote}"
  write_tempfile(data) do |input_path|
    convert_and_send(client, input_path)
  end
end

log "Usage: nc 127.0.0.1 #{LISTEN_PORT} < /path/to/input.xls > /path/to/output.#{TYPE}"
log ""

server = TCPServer.new('0.0.0.0', LISTEN_PORT)

loop do
  log "===== Listening port #{LISTEN_PORT} (convert type: #{TYPE}) ====="
  begin
    client = server.accept
    handle_client(client)
  rescue => e
    log %Q|ERROR: #{e.class}: #{e.message} #{e.backtrace.join("\n")}|
  ensure
    client.close rescue nil
  end
end
