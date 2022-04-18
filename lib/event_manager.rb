require 'csv'
require 'google/apis/civicinfo_v2'

form_letter = %{
    <html>
    <head>
      <title>Thank You!</title>
    </head>
    <body>
      <h1>Thanks FIRST_NAME!</h1>
      <p>Thanks for coming to our conference.  We couldn't have done it without you!</p>
  
      <p>
        Political activism is at the heart of any democracy and your voice needs to be heard.
        Please consider reaching out to your following representatives:
      </p>
  
      <table>
        <tr><th>Legislators</th></tr>
        <tr><td>LEGISLATORS</td></tr>
      </table>
    </body>
    </html>
  }

def legislators_by_zipcode(zip)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
    begin
      legislators = civic_info.representative_info_by_address(
        address: zip,
        levels: 'country',
        roles: ['legislatorUpperBody', 'legislatorLowerBody']
      )
      legislators = legislators.officials
      legislator_names = legislators.map(&:name)
      legislator_names.join(", ")
    rescue
      'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
end

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
        legislators = legislators_by_zipcode(zipcode)
        puts "#{name}  #{zipcode} #{legislators}"
    end
end