class RunAppCron
  @queue = :runappcron

  def self.perform(id)
    puts "run for #{id}"
    app = App.get id
    app.last_ran = Time.now
    app.save
  end
end
