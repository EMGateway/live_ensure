# LiveEnsure 

Library for implementing two-factor auth via liveensure.com.

## Getting Started

Add a line to your gemfile:

```ruby
gem 'live_ensure', :git => 'git@github.com:InspireStudios/live_ensure.git'
```

Create an initializer for your rails app:

```ruby
# /config/initializers/live_ensure.rb

LiveEnsure.configure do |config|
  config.api_key = 'KEY'
  config.api_password = 'PASSWORD'
  config.api_agent_id = 'AGENT_ID'
  config.enabled = true             # Leave this out if you want to set it per environment
end
```

Optionally, enable or disable per environment by adding to your development.rb/staging.rb/etc...

```ruby
LiveEnsure.configure { |config| config.enabled = true }
```

## Implementing LiveEnsure

* Refer to the guides at http://support.liveensure.com/forums/20038873-guides for more details. 

Request a token:

```ruby
@live_ensure = LiveEnsure.request_launch(email) 
session[:live_ensure_token] = @live_ensure.token
session[:live_ensure_base_url] = @live_ensure.base_url
```

Add to your view:

```ruby
<div id="live-ensure">
  <%= content_tag(:iframe, '', { src: @live_ensure.launch_url,  width: 320, height: 100, frameborder: 0}) %>
</div>
```

You will need to setup an action to handle a session check using the LiveEnsure.session_status method to detect when the user has successfully authenticated. I use something like this on my sessions controller:

```ruby
def check_auth
  if session[:live_ensure_token]
    response = LiveEnsure.session_status(session[:live_ensure_token], session[:live_ensure_base_url])
    result = { status: response.message }
  else
    result = { status: 'no-token' }
  end
  
  render json: result
end
```

Then I check it from the view using this javascript:

```javascript
<script type="text/javascript" charset="utf-8">
  var check_auth_interval;

  function checkAuth() {
    $.getJSON('/check_auth', function(data) {
      
      if (data.status == null || data.status == 'FAILED') {
        location.href = "/login"
        clearInterval(check_auth_interval);
        return;
      }
      
      if (data.status == 'SUCCESS') {
        location.href = '/complete_auth';
        clearInterval(check_auth_interval);
        return;
      }
    });
  }

  $(function() {
    check_auth_interval = setInterval(checkAuth, 1500);
  }); 
</script>

```

When you get a success message and redirect to the final step, do another check on the session status:

```ruby
response = LiveEnsure.session_status(session[:live_ensure_token], session[:live_ensure_base_url])

if response.valid?
  # do something here!
else
  # fail!
end
```

Want to contribute? Write specs, and send me a detailed pull request.