class Thank < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :from_who, presence: true
  validates :situation, presence: true
end
