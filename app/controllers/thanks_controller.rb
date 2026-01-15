class ThanksController < ApplicationController
  before_action :authenticate_user!

  def new
    @thank = Thank.new
  end

  def create
    @thank = current_user.thanks.build(thank_params)
    if @thank.save
      redirect_to root_path, notice: "ありがとう記録を保存しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def thank_params
    params.require(:thank).permit(:date, :from_who, :situation, :feeling)
  end
end
