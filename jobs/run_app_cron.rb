class RunAppCron
  @queue = :runappcron

  class << self
    def perform(id)
      app = App.get id
      if app
        puts "run for #{id}"
        record_attempt_for app
        app.enqueue_next
        app.save
        #do_job
      else
        puts "#{id} no longer present"
      end
    end

    private

    def record_attempt_for(app)
      app.last_attempted = Time.now
    end
  end
end
