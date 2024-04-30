require 'rails_helper'

RSpec.describe UserReview, type: :model do
  describe ".average_scores" do
    it do
      user = create(:user)
      create(:user_review, reviewee: user, score: 5)
      create(:user_review, reviewee: user, score: 4)
      create(:user_review) # 対象外
      expect(UserReview.average_scores.map { |r| [ r.reviewee_id, r.average_score ] }).to include([ user.id, 4.5 ])
    end
  end

  describe ".reviews_counts" do
    it do
      user = create(:user)
      create_list(:user_review, 3, reviewee: user)
      create(:user_review) # 対象外
      expect(UserReview.reviews_counts.map { |r| [ r.reviewee_id, r.reviews_count ] }).to include([ user.id, 3 ])
    end
  end

  describe ".user_reviews_counts" do
    it do
      user = create(:user)
      create_list(:user_review, 3, reviewer: user)
      create(:user_review) # 対象外
      expect(UserReview.user_reviews_counts.map { |r| [ r.reviewer_id, r.user_reviews_count ] }).to include([ user.id, 3 ])
    end
  end
end
