module ApplicationHelper
  def mobile_device?
    browser.device.mobile? || browser.device.tablet?
  end
end
