describe do
  Given(:subject) { :value }
  When(:result) { subject.to_s.length }
  Then { subject == :value }
  Then { result == 5 }
  context do
    Then { subject2 == 'value2' }
    Given(:subject2) { subject.to_s + "2" }
  end
end
