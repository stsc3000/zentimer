require 'csv'

class Entry::CSVRenderer
  attr_reader :entry

  def self.to_csv(entries)
    CSV.generate do |csv|
      csv << headers
      entries.each do |entry|
        csv << new(entry).to_csv_array
      end
    end
  end

  def self.headers
    [
      "Description",
      "Project",
      "Tags",
      "Elapsed (s)",
      "Running",
      "Current",
      "User",
      "Last Tick"
    ]
  end

  def initialize(entry)
    @entry = entry
  end

  def to_csv_array
    [ entry.description,
      entry.project,
      entry.tags.map(&:name).join(", "),
      entry.elapsed,
      entry.running,
      entry.current,
      entry.user.id,
      entry.lastTick
    ]
  end
end
