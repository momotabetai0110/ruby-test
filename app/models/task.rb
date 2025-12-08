class Task < ApplicationRecord
  belongs_to :category
  belongs_to :user

# validates :カラム名,バリデーション内容
# 【バリデーション内容】
# presence（空かどうか）
# length（文字数）
# numericality（数値かどうか）
# format（正しい形式かどうか）
# uniqueness（一意かどうか）

# カテゴリーID 必須
validates :category_id, presence: true

# ユーザーID 必須
validates :user_id, presence: true

# タイトル 必須かつ20文字まで
validates :title,
          presence: true,
          length: { maximum: 20 }

# 説明 100文字まで nil許容
validates :description,
          length: { maximum: 100 },
          allow_nil: true

# 期限 今日以降の日付
validate :check_due_date

private
def check_due_date
  return if due_date.nil?
  if due_date.to_date < Date.current
    errors.add(:due_date, "に過去を設定することはできません")
  end
end
end
