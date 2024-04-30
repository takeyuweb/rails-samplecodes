class UserReview < ApplicationRecord
  belongs_to :reviewer, class_name: "User", inverse_of: :user_reviews
  belongs_to :reviewee, class_name: "User", inverse_of: :reviews
  validates :score, presence: true, inclusion: { in: 1..5 }

  def self.average_scores
    group(:reviewee_id).select(:reviewee_id, Arel.sql("AVG(score) average_score"))
  end

  def self.reviews_counts
    group(:reviewee_id).select(:reviewee_id, Arel.sql("COUNT(*) reviews_count"))
  end

  def self.user_reviews_counts
    group(:reviewer_id).select(:reviewer_id, Arel.sql("COUNT(*) user_reviews_count"))
  end
end
