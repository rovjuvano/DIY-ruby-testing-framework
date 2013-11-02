describe 'Subject Under Test' do
  Given(:subject) { "I am Given" }
  Then { @subject =~ /Given Two/ }
  Then { @subject =~ /result/ }
  Then { fail 'exception' }
  Given { @subject += " Two" }
end
