class UserReview < ApplicationRecord
  belongs_to :reviewer, class_name: "User", inverse_of: :user_reviews
  belongs_to :reviewee, class_name: "User", inverse_of: :reviews
  validates :score, presence: true, inclusion: { in: 1..5 }
end
