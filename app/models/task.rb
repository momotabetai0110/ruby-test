class Task < ApplicationRecord
# validates :カラム名,バリデーション内容
# 【バリデーション内容】
# presence（空かどうか）
# length（文字数）
# numericality（数値かどうか）
# format（正しい形式かどうか）
# uniqueness（一意かどうか）
validates :title, presence: true
validates :user_id, presence: true
end
