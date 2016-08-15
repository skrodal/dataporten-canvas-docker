
class DataportenController < ApplicationController

  include PseudonymSessionsController
  include Login::Shared

  def create
    auth
  end

  def auth
    omniauth = request.env['omniauth.auth']['info']

    email = omniauth['email']
    name = omniauth['name']
    uid = omniauth['username']

    unique_id = uid.to_s

    # Look for existing user
    if (@pseudonym = Pseudonym.active.find_by_unique_id(email)) or
        (@pseudonym = Pseudonym.active.find_by_unique_id(unique_id))
      @domain_root_account.pseudonym_sessions.create!(@pseudonym, false)
      @user = @pseudonym.login_assertions_for_user
      # Login user
      return successful_login(@user, @pseudonym)
    else

      # User email/unique_id is not registered, create a new account (UsersController#create)
      @user ||= User.new

      @user.validation_root_account = @domain_root_account

      @user.name = name
      # TODO: FINN UT HVORDAN VI KAN LEGGE TIL PROFILBILDE
      # 'https://api.dataporten.no/userinfo/v1/user/media/' + profilephoto
      # 

      @pseudonym ||= @user.pseudonyms.build(:account => @domain_root_account)
      @pseudonym.require_password = false
      @pseudonym.user = @user

      # ID will not be email - use unique Dataporten ID instead
      @pseudonym.unique_id = unique_id

      @pseudonym.account = @domain_root_account
      @pseudonym.workflow_state = 'active'

      if @user.valid? && @pseudonym.valid?
        PseudonymSession.new(@pseudonym).save unless @pseudonym.new_record?
        @user.save!
        # Email is added as a communication channel and can only be created after saving the new user:
        @user.communication_channels.create!(:path_type => 'email', :path => email, :user => @user)
        
        # VIRKER IKKE ( undefined method `avatar' )
        #@user.avatar.create!(:url => 'https://api.dataporten.no/userinfo/v1/user/media/' + profilephoto, :user => @user)


        successful_login(@user, @pseudonym)
      else
        unsuccessful_login t('errors.invalid_credentials', "Incorrect username and/or password")
      end
    end
  end
end