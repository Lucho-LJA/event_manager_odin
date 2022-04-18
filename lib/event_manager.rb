require 'csv'
puts 'Event Manager Initialized!'

path_file = "event_attendees.csv"
if File.exist?(path_file)
    contest = CSV.open(
        path_file, 
        headers: true,
        header_converters: :symbol
    )
    contest.each do |row|
        name = row[:first_name]
        zipcode = row[:zipcode]
        puts "#{name} #{zipcode}"
    end
end