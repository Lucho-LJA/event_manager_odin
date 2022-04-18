require 'csv'
puts 'Event Manager Initialized!'

path_file = "event_attendees.csv"
if File.exist?(path_file)
    contest = CSV.open(path_file, headers: true)
    contest.each do |row|
        name = row[2]
        puts name
    end
end