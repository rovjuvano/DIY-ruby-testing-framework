describe do
  Given { puts 'Hello World' }
  Given(:name) { :value }
  Then { true }
  context do
    Given { puts 'inner' }
    Then { false }
  end
  Then { fail }
  Given { puts 'Goodbye World' }
end
