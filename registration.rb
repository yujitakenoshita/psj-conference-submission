#!/usr/bin/ruby
# coding: utf-8
print "Content-Type: text/html\n\n"

require 'cgi'
cgi = CGI.new


# 入力・修正画面の「確認」ボタンから呼びだされた場合
# select に confirm をセットしたのち、
# 入力ミスを確認し、エラーがあれば select を error に変更
# それ以外の場合、すなわち、最初の入力が「修正」ボタンから呼びだされた場合
# select に input をセット
# select が confirm か input か error かによって挙動を変える
if cgi["call"] == 'confirm' then
  select = 'confirm'
  if cgi["email"] != cgi["email2"]
    select = 'error'
    message = "Eメールアドレスが確認用と一致しません。Email address does not match.<br />"
  end
  if
    cgi["lname"] == ""
    select = 'error'
    message = message + "姓が未入力です。Missing Last name.<br />"
  end
  if
    cgi["fname"] == ""
    select = 'error'
    message = message + "名が未入力です。 Missing First name.<br />"
  end
  if
    cgi["affil"] == ""
    select = 'error'
    message = message + "所属が未入力です。 Missing affiliation.<br />"
  end
  if
    cgi["email"] == ""
    select = 'error'
    message = message + "E-Mailがが未入力です。Missing E-Mail.<br />"
  end
  if cgi["email2"] == ""
    select = 'error'
    message = message + "E-Mail(確認用)が未入力です。Missing E-Mail confirmation<br />"
  end
  if cgi["status"] == ""
    select = 'error'
    message = message + "会員種別がチェックされていません。 Membership not selected.<br />"
  end
else
  select = 'input'
end


# ラジオボタンとチェックボックスの値をセット
if cgi["status"] == "一般"
  full = "checked"
  student = ""
elsif cgi["status"] == "学生"
  full = ""
  full = "checked"
end

if banquet == "参加する"
  banquet = "checked"
else
  banquet = ""
end

# 入力・修正画面のヘッダ
reg_head = File.read('head-registration.html')

# 入力・修正画面のエラーメッセージ
reg_error_messages =
  "<p><span style='color: red'>入力内容に誤りがあります!</span> <br />\n" +
  "ご記入いただいた内容を再確認してください。<br />\n" +
  "<span style='color: red'>#{message}</span></p>\n"

# 入力・修正画面のフォーム部分
# hidden フォームで call変数にconfirmを代入している。
reg_input_form <<EOM
<form action="./registration.rb" method="post">
  <h2>お名前 Name</h2>
  <table>
    <tr><th>姓 Last name</th><th>名 First & middle name</th></tr>
    <tr>
      <td><input type="text" name="lname" value="#{cgi["lname"]}" size="20"/></td>
      <td><input type="text" name="fname" value="#{cgi["fname"]}"  size="15" /></td>
    </tr>
    <tr>
      <td class="ex">ex) 西郷; MOZART</td><td class="ex">ex) 隆盛; Wolfgang A.</td>
    </tr>
  </table>
  
  <h2>ご所属 Affiliation</h2>
  <table>
    <tr><td><input type="text" name="affil" value="#{cgi["affil"]}" size="90" /></td></tr>
    <tr><td class="ex">例) 鹿児島大・理; 京都大・霊長研 | Faculty of Sciences, Kagoshima Univ.; Primate Research Institute, Kyoto Univ.</td></tr>
  </table>
  
  <h2>電子メール E-Mail</h2>
  <table>
    <tr><td><input type="text" name="email" value="#{cgi["email"]}" size="50" /></td></tr>
    <tr><td><input type="text" name="email2" value="#{cgi["email"]}" size="50" />(確認用 Confirmation)</td></tr>
  </table>
  
  <h2>会員種別 Membership</h2>
  <table>
    <tr><td><input type="radio" name="status" value="一般" #{full} />一般 Full
	<input type="radio" name="status" value="学生" #{student} />学生 Student</td></tr>  
  </table>
  
  <h2>懇親会 Banquet</h2>
  <table>
    <tr><td><input type="checkbox" name="banquet" value="参加する" #{banquet} />参加する Attend</td></tr>
  </table>
  <input type="hidden" name="call" value="confirm" />
  <p style="text-align: center;"><input type="submit" name="kakunin" value="確認画面へ進む" /></p>
</form>
EOM


# 確認画面のhtmlソース
confirm = <<EOM
  <h1>参加情報の確認</h1>
  <p>下記の内容で参加申込を行ないますか？
     入力内容をご確認のうえ、誤りがなければ「上記の内容で申込む」を、修正事項があれば「修正する」をクリックしてください。</p>
  <hr />
<table>
<tr><th>お名前</th></tr>
<tr><td>#{cgi["lname"]} #{cgi["fname"]}</td></tr>
<tr><th>ご所属</th></tr>
<tr><td>#{cgi["affil"]}</td></tr>
<tr><th>電子メール</th></tr>
<tr><td>#{cgi["email"]}</td></tr>
<tr><th>会員種別</th></tr>
<tr><td>#{cgi["status"]}</td></tr>
<tr><th>懇親会</th></tr>
<tr><td>#{banquet}</td></tr>
</table>
EOM

# 確認画面の hiddenフォーム
reg_hidden_form = <<EOM
   <input type="hidden" name="lname" value="#{cgi["lname"]}" />
   <input type="hidden" name="fname" value="#{cgi["fname"]}" />
   <input type="hidden" name="affil" value="#{cgi["affil"]}" />
   <input type="hidden" name="email" value="#{cgi["email"]}" />
   <input type="hidden" name="status" value="#{cgi["status"]}" />
   <input type="hidden" name="banquet" value="#{banquet}" />
EOM

# 確認画面のボタン：申請か修正か
reg_button <<EOM
<form action="./submit.rb" method="post" style="display: inline">
  #{reg_hidden_form}
  <input type="submit" name="kakunin" value="上記の内容で申込む" />
</form>
<form action="./registration.rb" method="post" style="display: inline">
  #{reg_hidden_form}
  <input type="submit" name="kakunin" value="修正する" />
</form>
EOM
        
###################################
###   プログラム本体            ###
###################################

# 共通ヘッダ部分を出力
print File.read('head-common.html')

# selectの値によって、初期入力画面/エラー画面/確認画面を出力
case select
when 'input' then
  print reg_head
  print reg_input_form
when 'error' then
  print reg_head
  print reg_error_messages
  print reg_input_form
when 'confirm' then
  print reg_confirm
  print reg_button
else
  print '<p>原因不明のエラーが発生しました。<br />\n' +
        'おそれいりますが、もう一度最初の画面からやりなおしてください。</p>' +
        '<p>We are sorry, an error occured during process. <br />' +
        'Please return to registration page.</p>'
end

# 共通フッタ部分を出力
print File.read('foot-common.html')

