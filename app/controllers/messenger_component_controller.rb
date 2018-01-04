class MessengerComponentController < ApplicationController


  def index
    @FB_APP_ID = ENV['FB_APP_ID']
  end
  
  def webhook
    ret = "testing"
    if params["hub.verify_token"] == "test_token_123"
      ret = params["hub.challenge"]
    end
    render html: ret
  end

end
