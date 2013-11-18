describe do
  Given { puts 'Hello World' }
  Then { true }
  context do
    Given { puts 'inner' }
    Then { false }
  end
  Then { fail }
  Given { puts 'Goodbye World' }
end
