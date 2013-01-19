require './emcee'

# Create MC.
mc = Emcee.new(2)

# Train MC.
Dir['./raps/*.txt'].each do |file|
  song = File.read file
  mc.rehearse(song)
end

# Write rhymes.
chorus = mc.rap(4)
verse1 = mc.rap(16)
verse2 = mc.rap(16)

# Bust 'em out.
puts <<-EORAP

[Verse 1]
#{verse1}

[Chorus]
#{chorus}

[Verse 2]
#{verse2}

[Chorus]
#{chorus}

EORAP