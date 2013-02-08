  STORIES_FILE = "stories.csv"
  f = File.open(STORIES_FILE, 'r')
  story = {}
  while l = f.gets
    l.chomp!
    parts = l.split(",")
    if parts[0] =~ /[0-9]+/
      if story[:id]
        # Complete Story
        #puts "#{story[:id]} : #{story[:description]}"
        s = File.open("#{story[:id]}.feature", "w")
        s.puts "  Story: #{story[:id]}"
        s.puts "     #{story[:description]}"
        s.puts "\n\n\n\n"
        s.puts "#"
        s.puts "# Scenario 1"
        s.puts "#"
        s.puts "   Scenario: "
        s.puts "   Given  "
        s.puts "   When "
        s.puts "   Then "
        s.close
      end
      story[:id] = parts[0]
      story[:description] = parts[1]
    else
      story[:description] << "\n     "
      story[:description] << l
    end
    #puts "#{story[:id]} : #{story[:description]}"
    s = File.open("#{story[:id]}.feature", "w")
    s.puts "  Story: #{story[:id]}"
    s.puts "     #{story[:description]}"
    s.puts "\n\n\n\n"
    s.puts "#"
    s.puts "# Scenario 1"
    s.puts "#"
    s.puts "   Scenario: "
    s.puts "   Given  "
    s.puts "   When "
    s.puts "   Then "
    s.close
  end

