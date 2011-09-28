Indie::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[PA Exception]",
  :sender_address => %{"notifier" <welcome@pragauthor.com>},
  :exception_recipients => %w{alovak@gmail.com}
