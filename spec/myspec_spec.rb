describe 'Subject Under Test' do
  Given(:subject) { "subject" }
  When(:result) { "result" }
  Then { @subject == @result }
  onDone { puts @subject, @result }
end
