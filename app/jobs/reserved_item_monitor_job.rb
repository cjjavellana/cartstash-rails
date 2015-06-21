class ReservedItemMonitorJob
  include Sidekiq::Worker

  def perform(*args)
    # Do something later
  end
end
