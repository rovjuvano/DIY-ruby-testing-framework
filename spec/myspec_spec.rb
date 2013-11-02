describe 'Subject Under Test' do
  Given(:subject) { "I am Given" }
  Then { true }
  Then { false }
  Then { fail 'exception' }
  Given { puts "I am Given two" }
end
