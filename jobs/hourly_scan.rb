class HourlyScan
  @queue = :scans

  class << self
    def perform
      apps_to_run.each do |app|
        Resque.enqueue RunAppCron, app.id
      end
    end

    private

    def apps_to_run
      App.all
    end
  end
end
