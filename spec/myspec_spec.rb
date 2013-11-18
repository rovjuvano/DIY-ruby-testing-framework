Then { puts "Hello World" }
puts Object.public_method_defined?('Then') ? 'public' : 'not public'
puts Object.private_method_defined?('Then') ? 'private' : 'not private'
Object.send(:Then) { puts "Goodbye World" }
begin
  Object.Then { puts "And scene" }
rescue Exception => e
  puts e
end
