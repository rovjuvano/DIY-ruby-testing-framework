describe 'Subject Under Test' do
  Given { puts "I am Given" }
  Given { puts "I am Given two" }
  Then { true }
  Then { false }
  Then { fail 'exception' }
end
