describe do
  Given { puts 'Hello World' }
  Given(:name) { :value }
  Given(:name2) { name.to_s + "2" }
  Then { name == :value }
  Then { name2 == 'value2' }
  context do
    Given { puts 'inner' }
    Then { false }
  end
  Then { fail }
  Given { puts 'Goodbye World' }
end
