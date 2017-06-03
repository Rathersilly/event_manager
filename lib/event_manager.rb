require 'csv'
require "erb"
require "sunlight/congress"

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id, form_letter)
  Dir.mkdir("output") unless Dir.exists?("output")
  filename = "output/thanks_#{id}.html"

  File.open(filename, "w") do |file|
    file.puts form_letter
  end
end

def clean_phone_number(num)
  num.gsub!(/\D/, "")
  puts num
  length = num.length
  puts length
  if length < 10 || length > 11
    num = nil
  elsif length == 11
    if num[0] == 1
      num = num[1..-1]
    else
      num = nil
    end
  end
  return num

end

puts "EventManager Initialized!"

contents = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol)
puts contents.headers
template_letter = File.read("form_letter.erb")
erb_template = ERB.new(template_letter)

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = row[:zipcode]
  zipcode = clean_zipcode(zipcode)
  homephone = row[:homephone]
  puts homephone
  homephone = clean_phone_number(homephone)
  puts homephone
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)
    
#  save_thank_you_letters(id, form_letter)
end



