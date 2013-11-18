describe do
  Given { puts 'Hello World' }
  Then { true }
  context do
    Then { false }
  end
  Then { fail }
  Given { puts 'Goodbye World' }
end
