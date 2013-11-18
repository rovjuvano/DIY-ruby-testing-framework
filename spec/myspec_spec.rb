describe do
  Given { puts 'Hello World' }
  Then { true }
  Then { false }
  Then { fail }
  Given { puts 'Goodbye World' }
end
