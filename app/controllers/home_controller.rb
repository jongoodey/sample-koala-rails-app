class HomeController < ActionController::Base
  protect_from_forgery
  
   def index   
   	session[:oauth] = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET, SITE_URL + '/home/callback')
		@auth_url =  session[:oauth].url_for_oauth_code(:permissions=>"read_stream") 	
		puts session.to_s + "<<< session"
		  
	session[:signed_request] = session[:oauth].parse_signed_request(params[:signed_request])
	@a = session[:signed_request]['page']['liked']
	@b = session[:signed_request]['user_id']
	@c = session[:oauth].get_user_info_from_cookies(cookies)

  	respond_to do |format|
			 format.html {  }
		 end
	# oauth = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET)
 	# session[:signed_request] = oauth.parse_signed_request(params[:signed_request])
 	# @a = session[:signed_request]['page']['liked']

  end

	def callback
  	if params[:code]
  		# acknowledge code and get access token from FB
		  session[:access_token] = session[:oauth].get_access_token(params[:code])
		end		

		 # auth established, now do a graph call:
		  
		@api = Koala::Facebook::API.new(session[:access_token])
		begin
			@graph_data = @api.get_object("/me/statuses", "fields"=>"message")
		rescue Exception=>ex
			puts ex.message
		end
		
  
 		respond_to do |format|
		 format.html {   }			 
		end
		
	
	end
end

