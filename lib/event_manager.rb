puts 'Event Manager Initialized!'

path_file = "event_attendees.csv"
if File.exist?(path_file)
    contents = File.readlines(path_file)
    contents.each{|line| puts line}
end