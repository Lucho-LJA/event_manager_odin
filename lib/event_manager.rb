require 'csv'


def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
end

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
        zipcode = clean_zipcode(row[:zipcode])
        puts "#{name}  #{zipcode}"
    end
end