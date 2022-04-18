require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'



def legislators_by_zipcode(zip)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
    
    begin
      civic_info.representative_info_by_address(
        address: zip,
        levels: 'country',
        roles: ['legislatorUpperBody', 'legislatorLowerBody']
      ).officials
      #legislators = legislators.officials
      #legislator_names = legislators.map(&:name)
      #legislator_names.join(", ")

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
        name = row[:first_name]
        zipcode = clean_zipcode(row[:zipcode])
        legislators = legislators_by_zipcode(zipcode)
        form_letter = erb_template.result(binding)
        puts form_letter
    end
end