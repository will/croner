class HourlyScan
  @queue = :scans

  def self.perform
    puts 'scan'
  end
end
