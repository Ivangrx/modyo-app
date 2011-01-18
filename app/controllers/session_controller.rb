class SessionController < ApplicationController

  # Factory method for Consumer creation
  def self.consumer
    OAuth::Consumer.new(MODYO["key"], MODYO["secret"], :site => MODYO["site"])
  end

  # Actions

  def create

    @request_token = SessionController.consumer.get_request_token
    session[:request_token_token] = @request_token.token
    session[:request_token_secret] = @request_token.secret
    
    redirect_to @request_token.authorize_url
  end

  def login
    
  end

  def callback

    @request_token = OAuth::RequestToken.new(SessionController.consumer, session[:request_token_token], session[:request_token_secret])
    @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
     
    response = @access_token.get("/api/base/profile")
   
    user_info = Hpricot.parse(response.body)

    modyo_id = (user_info/:id).inner_html

    @user = User.find_by_modyo_id(modyo_id)
    if @user
      session[:user_id] = @user.id
      @user.update_attributes(:token => @access_token.token,
        :secret => @access_token.secret,
        :full_name => (user_info/:full_name).inner_html,
        :nickname => (user_info/:nickname).inner_html,
        :image_url => (user_info/:avatar).inner_html,
        :birthday => (user_info/:birthday).inner_html,
        :sex => (user_info/:sex).inner_html,
        :country => (user_info/:country).inner_html,
        :lang => (user_info/:lang).inner_html)
    else
      @user = User.new({ :modyo_id => (user_info/:id).inner_html,
          :token => @access_token.token,
          :secret => @access_token.secret,
          :full_name => (user_info/:full_name).inner_html,
          :nickname => (user_info/:nickname).inner_html,
          :image_url => (user_info/:avatar).inner_html,
          :birthday => (user_info/:birthday).inner_html,
          :sex => (user_info/:sex).inner_html,
          :country => (user_info/:country).inner_html,
          :lang => (user_info/:lang).inner_html })

      @user.save!
      @user.reload

      session[:user_id] = @user.id
    end

    session[:user] = {:token => @user.token,
      :secret => @user.secret,
      :full_name => @user.full_name,
      :nickname => @user.nickname,
      :image_url => @user.image_url,
      :birthday => @user.birthday,
      :sex => @user.sex,
      :country => @user.country,
      :lang => @user.lang}

    redirect_to root_url
  end

  def mail

    @user = current_user
    subjet = "Greetins from your new added app"
    message = "<p>Hello #{@user.full_name}.</p>
        <p>You recived a email from the new modyo app.</p>
        <p>Visit github modyo-app site for more information about the API.</p>
        <p>Regards Modyo Team.</p>"
    response = ModyoOauth::Connector.mail(@user, {:subjet => subjet, :message => message})

    render :xml => response
  end

  def feed

    @user = current_user
    options = {:description => "invited his friends to this great site: ", :linkable => "Modyo", :link => "http://www.modyo.com"}
    response = ModyoOauth::Connector.feed(@user, options)

    render :xml => response
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
