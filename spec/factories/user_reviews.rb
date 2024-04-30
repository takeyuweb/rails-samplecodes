FactoryBot.define do
  factory :user_review do
    association :reviewer, factory: :user
    association :reviewee, factory: :user
    score { rand(1..5) }
  end
end
