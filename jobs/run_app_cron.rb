class RunAppCron
  @queue = :runappcron

  class << self
    def perform(id)
      app = App.get id
      if app
        puts "run for #{id}"
        record_attempt_for app
        Resque.enqueue_in 10.seconds, self, id
        #do_job
      else
        puts "#{id} no longer present"
      end
    end

    private

    def record_attempt_for(app)
      app.last_attempted = Time.now
      app.save
    end
  end
end
