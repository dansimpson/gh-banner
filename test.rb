require "artii"
require "matrix"
require "date"
require "time"

# Find the first sunday after
# a given number of days
def sunday_after days_ago=0
  d = Date.today  - days_ago
  until d.sunday?
    d += 1
  end
  d
end

# Use ascii art to give us bitmap-like data
ascii = Artii::Base.new(font: "3x5").asciify "FUCK YEAH"

# Split out the rows and columns
rows  = ascii.split("\n").map { |l| l.split("") }

# Use matrix to give us columns, which we want
cols  = Matrix.rows(rows).column_vectors

# Pad each column with one extra empty day and
# give us a nice contingent set of days, where
# a hashtag yields commmits, and a blank yields
# no activity
days  = cols.map { |c| c.to_a + [" "] }.flatten


# Create our scratch pad
system "echo '' > log.data"
system "git add ."

# From the first sunday after 250 days
# ago, commit bogus commits to a file for 
# each day where we want a pixel to drop
date = sunday_after(250)
days.each { |item| 
  if item == "#"
    time = date.to_time + 3600 * 8

    # Do it 8 times to make it darker... 
    7.times do
      msg = "Commit for day #{time.iso8601}"
      system "echo '#{msg}' >> log.data"
      system "git commit -am '#{msg}'"
      system "GIT_COMMITTER_DATE='#{time.iso8601}' git commit --amend --date '#{time.iso8601}' -m '#{msg}'"     
      time += 3600
    end
  end
  date += 1
}
