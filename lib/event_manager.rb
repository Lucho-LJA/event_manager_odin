puts 'Event Manager Initialized!'

path_file = "event_attendees.csv"
contents = File.read(path_file)
if File.exist?(path_file)
    puts contents
end