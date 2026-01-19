class ThanksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_thank, only: [ :show, :edit, :update, :destroy ]

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

  def show
  end

  def edit
  end

  def update
    if @thank.update(thank_params)
      redirect_to thank_path(@thank), notice: "ありがとう記録を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @thank.destroy
    redirect_to thanks_path, notice: "ありがとう記録を削除しました"
  end

  private

  def set_thank
    @thank = current_user.thanks.find(params[:id])
  end

  def thank_params
    params.require(:thank).permit(:date, :from_who, :situation, :feeling)
  end
end
