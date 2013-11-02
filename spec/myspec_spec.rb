describe 'Subject Under Test' do
  Given { puts "I am Given" }
  Then { true }
  Then { false }
  Then { fail 'exception' }
end
