class CustomLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    "#{msg}\n"
  end
end

logfile = File.open(Rails.root + 'log/custom.log', 'a')
logfile.sync
CUSTOM_LOGGER = CustomLogger.new(logfile)