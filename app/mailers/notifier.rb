class Notifier < Devise::Mailer
  self.default :bcc => ['pavel@pragauthor.com', 'welcome@pragauthor.com']
end
