# Implements the technique for XSRF outlined in http://docs.angularjs.org/api/ng.$http#description_security-considerations_cross-site-request-forgery-protection
# In your `ApplicationController`:
#     include AngularCsrf
module AngularCsrf
  def self.included(klass)
    klass.after_filter :set_csrf_cookie_for_ng
  end

  protected

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end
end
