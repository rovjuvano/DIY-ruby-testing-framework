describe 'Subject Under Test' do
  Given(:subject) { "I am Given" }
  Then { @subject =~ /Given/ }
  Then { @subject =~ /result/ }
  Then { fail 'exception' }
  Given { puts "I am Given two" }
end
