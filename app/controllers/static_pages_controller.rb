class StaticPagesController < ApplicationController
  def top
    if user_signed_in?
      @random_thank = current_user.thanks.order("RANDOM()").first
    end
  end
end
