module Modyo
  module App
    class Session

      def self.consumer
        OAuth::Consumer.new(MODYO["key"],
          MODYO["secret"],
          {:site => MODYO["site"]})
      end

      def create

        @request_token = UsersController.consumer.get_request_token

        session[:request_token] = @request_token.token
        session[:request_token_secret] = @request_token.secret

        session[:return_to] = redirect_to_back_url
        session[:invitation_key]=params[:invitation_key]

        redirect_to @request_token.authorize_url

        # by default, the filter passes
        return true

      end

      def callback
        @request_token = OAuth::RequestToken.new(UsersController.consumer, session[:request_token],
          session[:request_token_secret])

        @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

        response = @access_token.get("/api/base/profile")

        user_info = Hpricot.parse(response.body)

        modyo_id = (user_info/:id).inner_html

        @user = User.find_by_modyo_id(modyo_id)
        if @user
          session[:user_id] = @user.id
          @user.update_attributes(:token => @access_token.token,
            :secret => @access_token.secret,
            :full_name => (user_info/:name).inner_html,
            :nickname => (user_info/:nickname).inner_html,
            :image_url => (user_info/:avatar).inner_html)
        else
          @user = User.new({ :modyo_id => (user_info/:id).inner_html,
              :full_name => (user_info/:name).inner_html,
              :nickname => (user_info/:nickname).inner_html,
              :image_url => (user_info/:avatar).inner_html,
              :token => @access_token.token,
              :secret => @access_token.secret })

          @user.save!
          @user.reload

          session[:user_id] = @user.id
          session[:welcome] = '1'

        end

        redirect_to root_url

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
  end
end
