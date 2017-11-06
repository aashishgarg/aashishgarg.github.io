---
layout: post
title: "Mobile number verification through sms with Twilio in Rails"
modified:
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2017-10-30T08:20:50-04:00
---

If sending SMS from your application(like phone no verification) is one of your requirement then Twilio is one of the solutions as a service provider for delivering SMS on your behalf.

There are two ways of implementing this in a Rails application - 
  * Traditional
  * Two-factor authentication

#### Traditional
* Create an account on [twilio](https://www.twilio.com/console).
* Get your Account SID and Auth Token.
* Add gem - 'gem 'twilio-ruby''
* Add twilio.yml in config with data - 

```yaml
development:  
  twilio_account_sid: your_account_sid
  twilio_auth_token: your_auth_token
  twilio_phone_number: phone_no_provided_by_twilio_to_send_sms_from
```
* Twilio phone number can be found in twilio console under section - 

<figure class="half">
	<img src="/images/phone.png" alt="image">
</figure>

* Create a session controller with two actions  -> send_otp and verify_otp.

 ```ruby
 def send_otp  
    if params[:user] && params[:user][:phone_no].present? && params[:user][:country_code].present?
       otp = SecureRandom.random_number(1000000)
       begin        
         otp_message = "Your one time password is #{otp}"        
         settings = YAML.load_file(File.join(Rails.root, 'config', 'twilio.yml'))[Rails.env]
         client = Twilio::REST::Client.new(settings['twilio_account_sid'], settings['twilio_auth_token'])
         client.messages.create(from: settings['twilio_phone_number'], to: (params['country_code'] + params['phone_no']), body: otp)
 
         json_response({message: 'OTP sent successfully.'})
       rescue => e        
         json_response({error: e.message}, :unprocessable_entity)
       end  
    else    
       json_response({error: 'Params are missing.'}, :not_acceptable)
    end
 end
 ```
* Save the sent otp in cache on your server.

```ruby
def verify_otp  
    if params[:user] && params[:user][:phone_no].present? && params[:user][:otp].present?
    saved_otp = CacheManagement.instance.get_value(params[:user][:phone_no])

      user = User.where(phone_no: params[:user][:phone_no]).take
      auth_token = SecureRandom.base64(12)
      if user.present?
        CacheManagement.instance.set_value(auth_token, user.id, User::AUTH_TOKEN_EXPIRY_TIME)
        json_response({error: 'User already exists.', user: user, auth_token: auth_token})
      else        
        build_resource(number_params)       
        resource.save
        CacheManagement.instance.set_value(auth_token, resource.id, User::AUTH_TOKEN_EXPIRY_TIME)
        json_response({message: 'User created successfully.', user: resource, auth_token: auth_token})
      end      
      # ---- If otp is not correct ----- #  
    else    
      json_response({error: 'Params are missing.'}, :not_acceptable)
    end
end
```

#### Two-factor authentication

Two-factor authentication is a solution where Twilio gets integrated with Authy and Authy send OTP and manages mobile verification. User sends a request to authy. Then authy sends opt to user via Twilio and then for verification also user send request to Authy and then authy verifies the OTP.

* Create an account on twilio.
* Get your Account SID and Auth Token.
* Setup Authy.
* Add Api keys. 
* Add gem - 'gem 'twilio-ruby''
* Add gem - 'gem 'authy''
* Add twilio.yml in config with data - 

```yaml
development:  
  twilio_account_sid: your_account_sid
  twilio_auth_token: your_auth_token
  twilio_phone_number: phone_no_provided_by_twilio_to_send_sms_from
  api_key: your_authy_api_key
  api_uri: https://api.authy.com/
```

* Create an authy.rb initializer with content -
 
```ruby
TWILIO_SETTINGS = YAML::load_file(File.join(Rails.root, 'config', 'twilio.yml'))[Rails.env]

Authy.api_key = TWILIO_SETTINGS['api_key']
Authy.api_uri = 'https://api.authy.com/'
```

* Create a session controller with two actions  -> send_otp and verify_otp.

```ruby
def send_otp  
  response = Authy::PhoneVerification.start(via: 'sms', country_code: params[:country_code], phone_number: params[:phone_no])
  render json: {response: response.message}, status: response.code
end

def verify_otp  
  response = Authy::PhoneVerification.check(verification_code: params[:otp], country_code: params[:country_code],
                                            phone_number: params[:phone_no])
  if response.ok?
    _user = User.find_or_initialize_by(phone_no: params[:phone_no], country_code: params[:country_code])
    if _user.new_record?
      if _user.save
        render json: {user: _user}, status: :ok      
      else        
         render json: {errors: _user.errors}, status: :unprocessable_entity      
      end    
     else      
       render json: {user: _user}, status: :ok    
     end  
    else    
      render json: {errors: [response.message]}, status: :unprocessable_entity  
    end
end
```

###### That's all you have to do for mobile number verification process implementation in your application.

