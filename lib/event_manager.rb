puts 'Event Manager Initialized!'

path_file = "event_attendees.csv"
if File.exist?(path_file)
    lines = File.readlines(path_file)
    row_index = 0
    lines.each do |line|
        row_index += 1
        next if row_index == 1
        colums = line.split(",")
        name = colums[2]
        puts name
    end
end