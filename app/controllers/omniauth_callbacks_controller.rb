class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    auth = request.env["omniauth.auth"]
    return :unauthorized unless Github.new.orgs.members.member?(ENV['GITHUB_ORG_NAME'], auth.info.nickname)

    user = User.where(uid: auth.uid).first_or_create do |user|
      user.uid = auth.uid
      user.username = auth.info.nickname
    end

    sign_in_and_redirect user
  end
end
