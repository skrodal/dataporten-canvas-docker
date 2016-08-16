# Canvas + Dataporten

Canvas user registration/login with Dataporten, utilising the OmniAuth Strategy for Dataporten (https://github.com/UNINETT/omniauth-dataporten).

This recipe has been tested step-by-step and found to be working beautifully.

With the following 'plugin', users may register/log in to Canvas with Dataporten:

- Canvas User ID === Dataporten `userid`
- Canvas Full Name === Dataporten `name`
- Canvas Default Email === Dataporten `email`

An account will be created automatically if it does not already exist.

** Register your client with Dataporten: **

- Set Redirect URI: `/auth/dataporten/callback` e.g. if on localhost on port 3000, then `http://127.0.0.1:3000/auth/dataporten/callback`
- Make note of your `CLIENT_ID` and `CLIENT_SECRET`
- Request scopes `userid`, `email` and `profile`

# Installation

## 1. Copy/edit files

Note: All paths presuming that current working dir is root for Canvas install (i.e. `canvas-lms`).

### 1.1. COPY `omniauth.rb`

Copy to `config/initializers/omniauth.rb`

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dataporten, 'CLIENT-ID', 'CLIENT-SECRET',
  redirect_url: 'http://127.0.0.1:3000'
end
```

### 1.2. EDIT `config/routes.rb`

> nano config/routes.rb

Paste the following lines inside `CanvasRails::Application.routes.draw do`:

```ruby
  # ADD CALLBACK ROUTE FOR DATAPORTEN AUTH
  get '/auth/dataporten/callback' => 'dataporten#create'
  resources :dataporten, :only => [:create]
```

### 1.3. COPY `omniauth_dataporten.rb`

Copy to Gemfile.d/omniauth_dataporten.rb

```ruby
gem 'omniauth-dataporten'
```

### 1.4. COPY `dataporten_controller.rb`

Copy to `app/controllers/dataporten_controller.rb`


### 1.5 (Optional) Add link to Dataporten auth on login page

1. Copy Dataporten svg from/to `public/images/sso_buttons/sso-dataporten.svg`
2. Edit `app/views/shared/_login_trailer.html.erb` to read something like this:

````
<div class="login-box" style="text-align: center;">
	<img alt="UNINETT Dataporten" src="/images/sso_buttons/sso-dataporten.svg" width="15">&nbsp;
	<%= link_to t("oauth_login", "Logg på med Dataporten"),  "/auth/dataporten/", :id => 'oauth_login' %>
</div>

````


## 2. Install

> \# bundle install

## 3. Restart server

Stop running instance:

> \# ps aux | egrep -i 'rails[^a-zA-Z]' | awk '{print $2}' | xargs kill

Start server (non-detached so you can observe server output in terminal): 

> \# bundle exec rails server

Stop server again with `CTRL+C`

...or `\# bundle exec rails server -d` to run in the background

## 4. Login to Canvas

Presuming Canvas is running on `http://127.0.0.1:3000/`

a) With Dataporten: 

> http://127.0.0.1:3000/auth/dataporten/

b) With Canvas

> http://127.0.0.1:3000/login/canvas/

## 5. Flow

On first login with Dataporten (e.g. via `http://127.0.0.1:3000/auth/dataporten/`), the user is taken to the consent form:

![Preview](/screenshots/dataporten_consent.png)

When accepted, user is redirected to `/auth/dataporten/callback` where the user details are employed to create the account.

Logged in as admin, the new user will appear in the list:

![Preview](/screenshots/canvas_dataporten_user.png)

And further details about the user may be observed by clicking the name:

![Preview](/screenshots/canvas_dataporten_user_details.png)



# (

### OPTIONAL: Install Canvas

If you do not already have a Canvas-installation, the following Dockerfile was used for testing:

<https://hub.docker.com/r/lbjay/canvas-docker/>

Default admin account for this image:

- username: `canvas@example.edu` 
- password: `canvas`


### Run the image

> docker run --name canvas -p 3000:3000 -d lbjay/canvas-docker 

### Enter the container to make changes

> docker exec -ti canvas env TERM=xterm bash -l

Nano may be handy for edits:

> apt-get install nano

# )