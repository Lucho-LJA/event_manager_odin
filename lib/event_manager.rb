puts 'Event Manager Initialized!'

path_file = "event_attendees.csv"
if File.exist?(path_file)
    lines = File.readlines(path_file)
    lines.each do |line|
        next if line == " ,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode\n"
        colums = line.split(",")
        name = colums[2]
        puts name
    end
end