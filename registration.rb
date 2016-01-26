#!/usr/bin/ruby
# coding: utf-8

def error_cgi
  print "Content-Type:text/html\n\n"
  print "*** CGI Error List ***<br />"
  print "#{CGI.escapeHTML($!.inspect)}<br />"
  $@.each {|x| print CGI.escapeHTML(x), "<br />"}
end

begin
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
    message = ""
    if cgi["email"] != cgi["email2"]
      select = 'error'
      message = "Eメールアドレスが確認用と一致しません。Email address does not match.<br />"
    end
    if
      cgi["name"] == ""
      select = 'error'
      message = message + "お名前が未入力です。Missing your name.<br />"
    end
    if
      cgi["affil"] == ""
      select = 'error'
      message = message + "所属が未入力です。 Missing affiliation.<br />"
    end
    if
      cgi["email"] == ""
      select = 'error'
      message = message + "E-Mailが未入力です。Missing E-Mail.<br />"
    end
    if cgi["email2"] == ""
      select = 'error'
      message = message + "E-Mail(確認用)が未入力です。Missing E-Mail confirmation<br />"
    end
    if cgi["status"] == ""
      select = 'error'
      message = message + "会員種別がチェックされていません。 PSJ Membership not selected.<br />"
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

  if cgi["banquet"] == "参加する"
    banquet = "checked"
  else
    banquet = ""
  end
  
  # 入力・修正画面のヘッダ
  reg_head = File.read('head-registration.html')
  
  # 入力・修正画面のエラーメッセージ
  reg_error_messages =
    "<p><span style='color: red'>入力内容に不備があります! Invalid field(s).</span> <br />\n" +
    "ご記入いただいた内容を再確認してください。Check input fields.<br />\n" +
    "<span style='color: red'>#{message}</span></p>\n"
  
  # 入力・修正画面のフォーム部分
  # hidden フォームで call変数にconfirmを代入している。
  reg_input_form = <<EOM
<form action="./registration.rb" method="post">
  <h2>お名前 Name</h2>
  <table>
    <tr><td><input type="text" name="name" value="#{cgi["name"]}" size="20"/></td></tr>
    <tr><td class="ex">example) 五代友厚; Worfgang A. MOZART</td></tr>
  </table>
  
  <h2>ご所属 Affiliation</h2>
  <table>
    <tr><td><input type="text" name="affil" value="#{cgi["affil"]}" size="90" /></td></tr>
    <tr><td class="ex">example) 鹿児島大・理; 京都大・霊長研; Fac. Sciences, Kagoshima Univ.; Primate Research Institut, Kyoto Univ.</td></tr>
  </table>
  
  <h2>電子メール E-Mail</h2>
  <table>
    <tr><td><input type="text" name="email" value="#{cgi["email"]}" size="50" /></td></tr>
    <tr><td><input type="text" name="email2" value="#{cgi["email"]}" size="50" />(確認用 Confirmation)</td></tr>
  </table>
  
  <h2>会員種別 PSJ Membership</h2>
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
  reg_confirm = <<EOM
  <h1>参加情報の確認</h1>
  <p>下記の内容で参加申込を行ないますか？ Are you sure to submit with following entries? <br />
     入力内容をご確認のうえ、誤りがなければ「上記の内容で申込む」を、修正事項があれば「修正する」をクリックしてください。<br />
     Check your entry and click "submit" or "modify".</p>
  <hr />
<table>
<tr><th>お名前 Name</th></tr>
<tr><td>#{cgi["name"]}</td></tr>
<tr><th>ご所属 Affiliation</th></tr>
<tr><td>#{cgi["affil"]}</td></tr>
<tr><th>電子メール E-Mail</th></tr>
<tr><td>#{cgi["email"]}</td></tr>
<tr><th>会員種別 PSJ membership</th></tr>
<tr><td>#{cgi["status"]}</td></tr>
<tr><th>懇親会 Banquet</th></tr>
<tr><td>#{banquet}</td></tr>
</table>
EOM

  # 確認画面の hiddenフォーム
  reg_hidden_form = <<EOM
   <input type="hidden" name="name" value="#{cgi["name"]}" />
   <input type="hidden" name="affil" value="#{cgi["affil"]}" />
   <input type="hidden" name="email" value="#{cgi["email"]}" />
   <input type="hidden" name="status" value="#{cgi["status"]}" />
   <input type="hidden" name="banquet" value="#{banquet}" />
EOM

  # 確認画面のボタン：申請か修正か
  reg_button = <<EOM
<form action="./submit.rb" method="post" style="display: inline">
  #{reg_hidden_form}
  <input type="submit" name="kakunin" value="上記の内容で申込む Submit" />
</form>
<form action="./registration.rb" method="post" style="display: inline">
  #{reg_hidden_form}
  <input type="submit" name="kakunin" value="修正する Modify" />
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
    print "<p>原因不明のエラーが発生しました。 Select: #{select}<br />\n" +
          'おそれいりますが、もう一度最初の画面からやりなおしてください。</p>' +
          '<p>We are sorry, an error occured during process. <br />' +
          'Please return to registration page.</p>'
  end
  
  # 共通フッタ部分を出力
  print File.read('foot-common.html')

rescue
  error_cgi
end
