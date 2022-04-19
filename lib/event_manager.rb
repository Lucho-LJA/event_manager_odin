require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'
require 'date'

def analize_days(contest)
    hash_days = Hash.new(0)
    contest.each do |row|
        date = Date.strptime(row[:regdate],"%m/%d/%y %H:%M").strftime("%A")
        hash_days[date] += 1
    end
    max_num = hash_days.values.max
    puts " The day/s that most people registered are: "
    hash_days.each do |key,value|
        if value == max_num
            puts "\t #{key}"
         end
    end
    puts "Whith #{max_num} times"
end

def analize_hours(contest)
    hash_hours = Hash.new(0)
    contest.each do |row|
        date = Time.strptime(row[:regdate],"%m/%d/%y %H:%M").hour
        hash_hours[date] += 1
    end
    max_num = hash_hours.values.max
    puts "The hours of the day the most people registered are: "
    hash_hours.each do |key,value|
        if value == max_num
            puts "\t #{key} hours"
         end
    end
    puts "Whith #{max_num} times"

end

def transform_number_phone(str_num)
    if str_num.include?("E+")
        str_num = str_num.to_f.to_i
        str_num = str_num.to_s
    end
    if str_num.include?("(")
        str_num.gsub!("(","")
    end
    if str_num.include?(")")
        str_num.gsub!(")","")
    end
    if str_num.include?(" ")
        str_num.gsub!(" ","")
    end
    if str_num.include?("-")
        str_num.gsub!("-","")
    end
    if str_num.include?(".")
        str_num.gsub!(".","")
    end
    str_num
end

def clean_number(name, phone_number)
    puts "verifying phone number #{phone_number} of #{name}"
    phone = transform_number_phone(phone_number.to_s)
    if phone.length == 10
        puts "\t number #{phone} is correct"
    elsif phone.length == 11 and phone[0] == "1"
        puts "\t number #{phone[1..phone.length]} is correct"
    else
        puts "\t number #{phone} is incorrect"
    end   
end

def save_thank_you_letter(id,form_letter)
    puts "Creating output/thanks_#{id}.html"
    Dir.mkdir('output') unless Dir.exist?('output')
  
    filename = "output/thanks_#{id}.html"
  
    File.open(filename, 'w') do |file|
      file.puts form_letter
    end
end

def legislators_by_zipcode(zip)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
    
    begin
      civic_info.representative_info_by_address(
        address: zip,
        levels: 'country',
        roles: ['legislatorUpperBody', 'legislatorLowerBody']
      ).officials

    rescue
      'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
end

def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
end

puts 'Event Manager Initialized!'

path_file = "event_attendees.csv"
path_template_letter = 'template_letter.erb'


if File.exist?(path_file) and File.exist?(path_template_letter)
    contest = CSV.open(
        path_file, 
        headers: true,
        header_converters: :symbol
    )
    template_letter = File.read(path_template_letter)
    erb_template = ERB.new template_letter
    contest.each do |row|
        id = row[0]
        name = row[:first_name]
        zipcode = clean_zipcode(row[:zipcode])
        legislators = legislators_by_zipcode(zipcode)
        form_letter = erb_template.result(binding)
        save_thank_you_letter(id,form_letter)
        
        #uncomment the next line to print phone number and verificate  number
        clean_number(name, row[:homephone])  
    end
    #uncomment the next lines to print hours of the day the most people registered
    contest = CSV.open(
        path_file, 
        headers: true,
        header_converters: :symbol
    )
    analize_hours(contest)
    #uncomment the next lines to print the day of the most people registered
    contest = CSV.open(
        path_file, 
        headers: true,
        header_converters: :symbol
    )
    analize_days(contest)
   
    puts "Event Manager Finished!"
end