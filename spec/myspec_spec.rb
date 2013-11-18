describe do
  Given(:subject) { :value }
  And(:G2) { :g2 }
  When(:result) { subject.to_s.length }
  And(:W2) { :w2 }
  Then { subject == :value }
  Then { result == 5 }
  context do
    Then { subject2 == 'value2' }
    Given(:subject2) { subject.to_s + "2" }
  end
  context do
    When { fail 'Did this fail' }
    Then { has_failed /Did this fail/ }
    context do
      When { fail 'Woops I did it again' }
      Then { has_failed /Did this fail/ }
    end
  end
end
