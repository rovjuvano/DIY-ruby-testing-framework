describe 'Subject Under Test' do
  Given(:subject) { "I am Given" }
  Then { @result =~ /Given Two/ }
  Then { @result =~ /result/ }
  Then { fail 'exception' }
  When(:result) { @subject + " Two" }
  context 'when under conditions' do
    Given(:new_subject) { "I am nested Given" }
    When(:new_result) { @new_subject + " Two" }
    Then { @new_result =~ /nested Given Two/ }
    Then { @result =~ /Given Two/ }
  end
end
