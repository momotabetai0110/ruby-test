class Category < ApplicationRecord
  # カテゴリー名 必須、30文字まで、一意
  validates :name,
            presence: true,
            length: { maximum: 30 },
            uniqueness: true

  # カテゴリー説明 200文字まで nil許容
  validates :description,
            length: { maximum: 200 },
            allow_nil: true
end
