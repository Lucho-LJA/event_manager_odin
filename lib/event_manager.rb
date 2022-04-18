puts 'Event Manager Initialized!'

path_file = "event_attendees.csv"
if File.exist?(path_file)
    lines = File.readlines(path_file)
    lines.each_with_index do |line, index|
        next if index == 0
        colums = line.split(",")
        name = colums[2]
        puts name
    end
end