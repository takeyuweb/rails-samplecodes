class CreateUserReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :user_reviews do |t|
      t.references :reviewer, null: false, foreign_key: { to_table: :users }
      t.references :reviewee, null: false, foreign_key: { to_table: :users }
      t.integer :score, null: false

      t.timestamps
    end
  end
end
