class ThanksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_thank, only: [ :show ]  # 追加

  def index
    @thanks = current_user.thanks.order(date: :desc)
  end

  def new
    @thank = Thank.new
  end

  def create
    @thank = current_user.thanks.build(thank_params)
    if @thank.save
      redirect_to thanks_path, notice: "ありがとう記録を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 追加
  def show
  end

  private

  # 追加
  def set_thank
    @thank = current_user.thanks.find(params[:id])
  end

  def thank_params
    params.require(:thank).permit(:date, :from_who, :situation, :feeling)
  end
end
