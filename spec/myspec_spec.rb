describe 'Subject Under Test' do
  Given(:subject) { "I am Given" }
  Then { @subject =~ /Given Two/ }
  Then { @subject =~ /result/ }
  Then { fail 'exception' }
  When { @subject += " Two" }
  context 'when under conditions' do
    Given(:new_subject) { "I am nested Given" }
    When { @new_subject += " Two" }
    Then { @new_subject =~ /nested Given Two/ }
    Then { @subject =~ /Given Two/ }
  end
end
