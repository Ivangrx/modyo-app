class ModyoOauth::Connector


  def self.mail(user, options = {})

    @access_token = OAuth::AccessToken.new(SessionController.consumer, user.token, user.secret)
    response = @access_token.post("/api/base/mailer", {:recipient => user.modyo_id, :message => options[:message], :subjet => options[:subjet]})
    user_info = Hpricot.parse(response.body)
    return user_info
   
  end

def self.feed(user, options = {})
    @access_token = OAuth::AccessToken.new(SessionController.consumer, user.token, user.secret)
    response =  @access_token.post("/api/base/feed", {:recipient => user.modyo_id, :description => options[:description], :linkable => options[:linkable], :link => options[:link]})
    user_info = Hpricot.parse(response.body)
    return user_info
end



end