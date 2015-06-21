set :environment, "development"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every 2.hours do
  runner "ReservedItem.return_to_inventory"
end