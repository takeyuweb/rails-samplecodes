require 'rails_helper'

RSpec.describe User, type: :model do
  example "平均スコアが4以上のユーザーを探す" do
    users = create_list(:user, 6)
    score_5 = users[0].tap do |user|
      create(:user_review, reviewee: user, reviewer: users[4], score: 5)
    end
    score_4_5 = users[1].tap do |user|
      create(:user_review, reviewee: user, reviewer: users[4], score: 5)
      create(:user_review, reviewee: user, reviewer: users[3], score: 4)
    end
    score_4 = users[2].tap do |user|
      create(:user_review, reviewee: user, reviewer: users[4], score: 5)
      create(:user_review, reviewee: user, reviewer: users[3], score: 3)
    end
    users[3].tap do |user|
      create(:user_review, reviewee: user, reviewer: users[4], score: 4)
      create(:user_review, reviewee: user, reviewer: users[2], score: 3)
      create(:user_review, reviewee: user, reviewer: users[1], score: 3)
    end
    users[4].tap do |user|
      create(:user_review, reviewee: user, reviewer: users[3], score: 3)
    end

    average_scores = UserReview.average_scores
    reviews_count = UserReview.reviews_counts
    user_reviews_count = UserReview.user_reviews_counts
    users_with_average_score = User.with(average_scores:, reviews_count:, user_reviews_count:)
      .joins("LEFT OUTER JOIN average_scores ON users.id = average_scores.reviewee_id")
      .joins("LEFT OUTER JOIN reviews_count ON users.id = reviews_count.reviewee_id")
      .joins("LEFT OUTER JOIN user_reviews_count ON users.id = user_reviews_count.reviewer_id")

    expect(users_with_average_score).to match_array(User.all)
    # 平均スコアが4以上のユーザーを探す
    expect(users_with_average_score.where("average_score >= ?", 4)).to match_array([ score_5, score_4_5, score_4 ])
    # レビューが3件以上あるユーザーを探す
    expect(users_with_average_score.where("reviews_count >= ?", 3)).to match_array([ users[3] ])
    # レビューを3件以上書いたユーザーを探す
    expect(users_with_average_score.where("user_reviews_count >= ?", 3)).to match_array([ users[3], users[4] ])

    user = users_with_average_score.select(Arel.sql("users.*, average_score, reviews_count, user_reviews_count")).find(score_5.id)
    expect(user.average_score).to eq(5.0)
    expect(user.reviews_count).to eq(1)
    expect(user.user_reviews_count).to eq(nil)
  end
end
