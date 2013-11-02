describe 'Subject Under Test' do
  Given(:subject) { "I am Given" }
  Then { result =~ /Given Two/ }
  Then { result =~ /result/ }
  Then { fail 'exception' }
  When(:result) { subject + " Two" }
  context 'when under conditions' do
    Given(:new_subject) { "I am nested Given" }
    When(:new_result) { new_subject + " Two" }
    Then { new_result =~ /nested Given Two/ }
    Then { result =~ /Given Two/ }
  end
  context 'Givens/Whens only called once' do
    Given { @givens = "G" }
    Given(:givens) { @givens += "G" }
    When() { @whens = "W" }
    When(:whens) { @whens += "W" }
    When(:result1) { givens + whens }
    When(:result2) { givens + whens }
    Then { result1 == 'GGWW' && result2 == 'GGWW' }
  end
end
