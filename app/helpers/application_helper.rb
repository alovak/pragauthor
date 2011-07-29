module ApplicationHelper
  def controller_css_scope_name
    controller_name.gsub('/', '__')
  end
end
