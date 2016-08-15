# Canvas + Dataporten

Canvas user registration/login with Dataporten, utilising the OmniAuth Strategy for Dataporten (https://github.com/UNINETT/omniauth-dataporten).

With the following 'plugin', users may register/log in to Canvas with Dataporten:

- Canvas User ID === Dataporten `userid`
- Canvas Full Name === Dataporten `name`
- Canvas Default Email === Dataporten `email`

An account will be created automatically if it does not already exist.

** Register your client with Dataporten: **

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
gem 'omniauth'
gem 'omniauth-dataporten'
```

### 1.4. COPY `dataporten_controller.rb`

Copy to `app/controllers/dataporten_controller.rb`

## 2. Install

> \# bundle install

## 3. Restart server

Stop running instance:

> \# ps aux | egrep -i 'rails[^a-zA-Z]' | awk '{print $2}' | xargs kill

Start server: 

> \# bundle exec rails server

Stop server again with `CTRL+C`

## 4. Login to Canvas

Presuming Canvas is running on `http://127.0.0.1:3000/`

a) With Dataporten: 

> http://127.0.0.1:3000/auth/dataporten/

b) With Canvas

> http://127.0.0.1:3000/login/canvas/

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