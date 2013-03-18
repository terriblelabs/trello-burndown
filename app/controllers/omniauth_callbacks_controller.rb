class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    auth = request.env["omniauth.auth"]
    user = User.where(uid: auth.uid).first_or_create do |user|
      user.uid = auth.uid
      user.username = auth.info.nickname
    end

    sign_in_and_redirect user
  end
end
