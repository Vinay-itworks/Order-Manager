class User::UserController < ApplicationController
  def about
    @user = current_user
  end
end
