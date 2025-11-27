# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

#本来seeds.rb は「何度実行しても重複レコードが増えない」ことが推奨されている
Task.create!(
    title: "買い物リスト作成",
    description: "週末の食材を整理する"
  )
  Task.create!(
    title: "レポート提出",
    description: "月次レポートのドラフトを金曜までに",
  )
  Task.create!(
    title:"企業面接",
    description:nil
  )