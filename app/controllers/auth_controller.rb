class AuthController < ApplicationController
  def login
    user = User.find_by(username: login_params[:username])
    if user && user.authenticate(login_params[:password])
      token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base, 'HS256')
      render json: { user: user, token: token }
    else
      render json: {}, status: 401
    end
  end

  def persist
    if request.headers['Authorization']
      encoded_token = request.headers['Authorization']
      begin
        token = JWT.decode(encoded_token, Rails.application.secret_key_base, true, algorithm: 'HS256')
        user_id = token[0]['user_id']
        user = User.find(user_id)
        render json: user
      rescue
        render json: {}, status: 401
      end
    else
      render json: {}, status: 401
    end
  end

  private

  def login_params
    params.permit(:username, :password)
  end
end