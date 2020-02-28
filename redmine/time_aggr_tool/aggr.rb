#!/usr/bin/env ruby
require 'csv'
require 'bigdecimal'

TicketCsvFile = ARGV[0]
TimeLogCsvFile = ARGV[1]
$date_begin = Date.parse ARGV[2]
$date_end   = Date.parse ARGV[3]

if !TicketCsvFile || !TimeLogCsvFile
  STDERR.puts "Usage: #{$0} <TicketCsvFile> <TimeLogCsvFile> <date_begin> <date_end>"
  exit 1
end


def read_csv(filepath)
  str = File.read(filepath, encoding: 'CP932')
  CSV.parse str.encode('UTF-8')
end

def parse_date(date_str)
  return nil if date_str.length == 0
  Date.parse date_str
end

class TicketParser
  def self.parse_csv(filepath)
    read_csv(filepath).drop(1).map {|entry| parse entry }
  end
  def self.parse(raw_entry)
    Ticket.from_csv raw_entry
  end
end

class TicketSet
  def initialize(tickets)
    @tickets = {}
    tickets.each { |t| add t }
  end

  def add(ticket)
    @tickets[ticket.id] = ticket
  end

  def analyze_tree
    @root = {}
    @tickets.each do |id, ticket|
      if ticket.parent_id
        parent = @tickets[ticket.parent_id]
        unless parent
          warn "Ticket ##{ticket.parent_id} not found. referenced by ticket[#{ticket.inspect}]"
          next
        end
        parent.add_child(ticket)
      else
        @root[id] = ticket
      end
    end
    @root
  end

  def tree
    analyze_tree unless @root
    @root
  end

  def find_by_id(id)
    @tickets[id]
  end
end

class Ticket
  attr_accessor :id, :parent_id, :project_name, :tracker, :status, :title, :start_date, :finish_date, :yotei_kosu, :progress, :desc
  attr_reader :children, :time_logs

  def self.from_csv(row)
    Ticket.new.tap do |obj|
      obj.id = row[0].to_i
      obj.parent_id = row[3].to_i # 親チケット
      obj.parent_id = nil if obj.parent_id==0
      obj.status = row[4]
      obj.title = row[6]
      obj.start_date =  parse_date(row[12])
      obj.finish_date = parse_date(row[13])
      obj.yotei_kosu = row[14].to_f
      obj.progress = row[18].to_f
      obj.desc = row[23]&.gsub(/\r\n/, ' ')&.truncate(32)
    end
  end

  def add_child(ticket)
    if @children
      @children << ticket
    else
      @children = [ticket]
    end
  end

  def add_time_log(time_log)
    if @time_logs
      @time_logs << time_log
    else
      @time_logs = [time_log]
    end
  end
end

class TimeLogParser
  def self.parse_csv(filepath)
    read_csv(filepath).drop(1).map {|entry| parse entry }
  end
  def self.parse(raw_entry)
    TimeLog.from_csv raw_entry
  end
end

class TimeLog
  attr_accessor :project_name, :date, :user, :ticket_id, :comment, :hours, :activity

  def self.from_csv(row)
    TimeLog.new.tap do |obj|
      obj.project_name = row[0]
      obj.date = parse_date(row[1])
      obj.user = row[3]
      obj.activity = row[4]
      if row[5] =~ /\S+ \#(\d+)/
        obj.ticket_id = $1.to_i
      end
      obj.comment = row[6]
      obj.hours = BigDecimal.new(row[7]).truncate(2).to_f
    end
  end
end

class TimeSummary
  attr_reader :min_date, :max_date, :design, :develop, :other, :comulative

  def add(time_log)
    if $date_begin <= time_log.date && time_log.date <= $date_end
      @min_date = [@min_date, time_log.date].compact.min
      @max_date = [@max_date, time_log.date].compact.max
      case time_log.activity
      when '設計作業'
        @design = (@design || 0) + time_log.hours
      when '開発作業'
        @develop = (@develop || 0) + time_log.hours
      else
        @other = (@other || 0) + time_log.hours
      end
    end
    @comulative = (@comulative || 0) + time_log.hours
  end

  def self.from_time_logs(time_logs)
    TimeSummary.new.tap do |ts|
      time_logs.each { |l| ts.add(l) }
    end
  end

  def total
    (@design||0) + (@develop||0) + (@other||0)
  end
end

tickets = TicketSet.new TicketParser.parse_csv(TicketCsvFile)
TimeLogParser.parse_csv(TimeLogCsvFile).each do |time_log|
  #STDERR.puts time_log.inspect
  t = tickets.find_by_id(time_log.ticket_id)
  unless t
    warn "Ticket ##{time_log.ticket_id} not found. referenced by timelog[#{time_log.inspect}]"
    next
  end
  t.add_time_log(time_log)
end

def dump(tickets, depth=0)
  tickets = if tickets.is_a? TicketSet
              tickets.tree.values
            else
              tickets.to_a
            end
  list = []
  tickets.each do |t|
    a = [t.id, t.parent_id, ('├　'*depth)+t.title, t.start_date, t.finish_date, t.status, t.yotei_kosu]
    times = t.time_logs&.group_by{|log| log.user}&.map do |user, logs|
      ts = TimeSummary.from_time_logs logs
      [user, ts.min_date, ts.max_date, ts.design, ts.develop, ts.other, ts.total, ts.comulative]
    end
    a << times
    list << a
    if t.children
      list += dump(t.children, depth+1)
    end
  end
  list
end

rows = Enumerator.new do |y|
  dump(tickets).each do |result|
    row = []
    sub_rows = []
    result.each_with_index do |elem, i|
      if elem.is_a? Array
        bkup = row
        row += elem.take(1)
        elem.drop(1).each do |sub_row|
          #sub_rows << Array(i+1){''} + sub_row
          sub_rows << bkup + sub_row
        end
      else
        row << elem
      end
    end
    y.yield row.flatten
    sub_rows.each { |sb| y.yield sb }
  end
end

puts %w/# 親# タイトル 開始 終了 ステータス 予定工数 担当者 作業From 作業To 設計 開発 他 小計 累積/.to_csv
rows.each do |row|
  puts row.to_csv
end

