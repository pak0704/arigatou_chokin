class ThanksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_thank, only: [ :show, :edit, :update, :destroy ]

  def index
    @thanks = current_user.thanks.order(date: :desc)

    # 検索条件の適用
    if params[:from_date].present?
      @thanks = @thanks.where("date >= ?", params[:from_date])
    end

    if params[:to_date].present?
      @thanks = @thanks.where("date <= ?", params[:to_date])
    end

    if params[:from_who].present?
      @thanks = @thanks.where("from_who LIKE ?", "%#{params[:from_who]}%")
    end

    if params[:situation].present?
      @thanks = @thanks.where("situation LIKE ?", "%#{params[:situation]}%")
    end
    @thanks = @thanks.page(params[:page]).per(10)
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
