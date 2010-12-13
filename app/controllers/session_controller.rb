class SessionController < ApplicationController

  # Factory method for Consumer creation
  def self.consumer
    OAuth::Consumer.new(MODYO["key"], MODYO["secret"], :site => MODYO["site"])
  end

  # Actions

  def create

    @request_token = SessionController.consumer.get_request_token
    session[:request_token] = @request_token
    
    redirect_to @request_token.authorize_url
  end

  def login
    
  end

  def callback

    @request_token = OAuth::RequestToken.new(SessionController.consumer, session[:request_token].token,
      session[:request_token].secret)

    @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

    response = @access_token.get("/api/base/profile")

    user_info = Hpricot.parse(response.body)

    @user = { :modyo_id => (user_info/:id).inner_html,
      :name => (user_info/:name).inner_html,
      :nickname => (user_info/:nickname).inner_html,
      :image_url => (user_info/:avatar).inner_html,
      :token => @access_token.token,
      :secret => @access_token.secret }

    session[:user] = @user

    redirect_to root_url
  end

  def destroy
    session[:user] = nil

    redirect_to_back
  end

  protected

  def redirect_to_back(redirect_opts = nil)
    redirect_to redirect_to_back_url(redirect_opts)
  end

  def redirect_to_back_url(redirect_opts = nil)
    redirect_opts ||= {:controller => '/'}
    request.env["HTTP_REFERER"] ? (request.env["HTTP_REFERER"]) : (redirect_opts)
  end

end
