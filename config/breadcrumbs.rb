crumb :root do
  link "トップページ", root_path
end

crumb :mypage do
  link "マイページ", mypage_user_path
end

crumb :user_profiles do
  link "本人情報の登録", identification_user_path
  parent :mypage
end

crumb :change_profiles do
  link "本人情報の登録", change_profile_user_path
  parent :mypage
end

crumb :creditcards do
  link "支払い方法", creditcards_path
  parent :mypage
end

# crumb :identification do
#   link "ログアウト", identification_path
#   parent :mypage
# end