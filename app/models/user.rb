class User < ApplicationRecord
  # 自分に対してのレビュー
  has_many :reviews, class_name: "UserReview", foreign_key: :reviewee_id, dependent: :destroy
  # 自分が書いたレビュー
  has_many :user_reviews, class_name: "UserReview", foreign_key: :reviewer_id, dependent: :destroy
end
