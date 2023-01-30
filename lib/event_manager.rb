require "csv"
require 'google/apis/civicinfo_v2'
require "erb"
civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
response = civic_info.representative_info_by_address(address: 80202, levels: 'country', roles: ['legislatorUpperBody', 'legislatorLowerBody'])


def clean_zipcode(zipcode)
    # if zipcode == nil
    #     zipcode = "00000"
    # end
    # if zipcode.length <5
    #     zipcode = zipcode.rjust(5, '0')
    # end
    # if zipcode.length > 5
    #     zipcode = zipcode[0..4]
    # end
    # zipcode
    
    zipcode = zipcode.to_s.rjust(5, '0')[0..4]


end

def legislators_by_zipcode(zipcode)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
    begin
        legislators = civic_info.representative_info_by_address(
            address: zipcode,
            levels: 'country',
            roles: ['legislatorUpperBody', 'legislatorLowerBody']
        )
        legislators = legislators.officials
        legislator_names = legislators.map do |legislator|
            legislator.name
          end
          legislator_string = legislator_names.join(", ")
        
    rescue
        'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
    
end

def save_thank_you_letter(id, form_letter)
    Dir.mkdir('output') unless Dir.exist?('output')
    filename = "output/thanks_#{id}.html"


    File.open(filename, "w") do |file|
            file.puts form_letter
    end

end
# def clean_phone_number(phone_number)
#     if phone_number.length < 10
#         phone_number = '0'
#         phone_number.rjust(10, '0')
#     end 
# end

puts 'Event Manager Initialized!'
#with library
template_letter = File.read("form_letter.erb")
erb_template = ERB.new(template_letter)

contents = CSV.open("event_attendees.csv",
     headers: true,
    header_converters: :symbol)
contents.each do |row|
    id = row[0]
    phone_number = row[:homephone]
    phone_number = clean_phone_number(phone_number)
    name = row[:first_name]
    zipcode = row[:zipcode]
    zipcode = clean_zipcode(zipcode)
    legislators = legislators_by_zipcode(zipcode)
    # personal_letter = template_letter.gsub("FIRST_NAME", name)
    # personal_letter = template_letter.gsub!("LEGISLATORS", legislators)
    form_letter = erb_template.result(binding)

    
    save_thank_you_letter(id, form_letter)
end

# Assignment: Clean Phone Numbers
# Similar to the zip codes, the phone numbers suffer from multiple formats and inconsistencies. If we wanted to allow individuals to sign up for mobile alerts with the phone numbers, we would need to make sure all of the numbers are valid and well-formed.

# If the phone number is less than 10 digits, assume that it is a bad number
# If the phone number is 10 digits, assume that it is good
# If the phone number is 11 digits and the first number is 1, trim the 1 and use the remaining 10 digits
# If the phone number is 11 digits and the first number is not 1, then it is a bad number
# If the phone number is more than 11 digits, assume that it is a bad number
# Assignment: Time Targeting
# The boss is already thinking about the next conference: “Next year I want to make better use of our Google and Facebook advertising. Find out which hours of the day the most people registered, so we can run more ads during those hours.” Interesting!

# Using the registration date and time we want to find out what the peak registration hours are.

# Ruby has Date and Time classes that will be very useful for this task.

# For a quick overview, check out this Ruby Guides article.

# Explore the documentation to become familiar with the available methods, especially #strptime, #strftime, and #hour.

# Assignment: Day of the Week Targeting
# The big boss gets excited about the results from your hourly tabulations. It looks like there are some hours that are clearly more important than others. But now, tantalized, she wants to know “What days of the week did most people register?”

# Use Date



#wday to find out the day of the week.




#without library
# puts "split ,"
# lines = File.readlines("event_attendees.csv")
# lines.each_with_index do |line, index|
#     next if index == 0
#     column = line.split(",")
#     name = column[2]

#     puts name
# end