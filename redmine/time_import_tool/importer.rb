require 'json'

# rails console で直接以下のクラスを貼り付けて、newして parse() を呼んでください。
class TimeEntryParser
  def parse_json_file(json_file)
    f = File.read json_file
    JSON.parse(f, symbolize_names: true)
  end

  def parse(file)
    cnt = 0
    parse_json_file(file).sort_by{|x| x[:id]}.each do |time_entry|
      cnt += 1 if aaa time_entry
    end
    cnt
  end

  def aaa(e)
    t = TimeEntry.find_by(id: e[:id]) || TimeEntry.new
    t.project_id = e[:project][:id]
    t.user_id = e[:user][:id]
    t.issue_id = e[:issue][:id]
    t.hours = e[:hours]
    t.comments = e[:comments]
    t.activity_id = e[:activity][:id]
    t.spent_on = Date.parse e[:spent_on]
    t.created_on = Time.parse e[:created_on]
    t.updated_on = Time.parse e[:updated_on]

    return nil unless t.changed?

    unless t.valid?
      p t
      raise t.errors
    end
    t.save!(touch: false)
    t
  end
end

