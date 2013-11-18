describe do
  Given(:subject) { :value }
  Then { subject == :value }
  context do
    Then { subject2 == 'value2' }
    Given(:subject2) { subject.to_s + "2" }
  end
end
