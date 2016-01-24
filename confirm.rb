#!/usr/bin/ruby
# coding: utf-8
print "Content-Type: text/html\n\n"

require 'cgi'
cgi = CGI.new

print <<EOM
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="css/form.css" rel="stylesheet" type="text/css" />
<title>第32回日本霊長類学会大会</title>
</head>
<body>
  <div id="header">
    <h1 id="title">第32回日本霊長類学会大会</h1>
    <h2 id="date">2016年7月15日〜17日　鹿児島大学郡元キャンパス</h2>
  </div>
  <div id="main">
  <hr />
EOM

banquet = cgi["banquet"]
#cgi.delete("banquet")

error = 0
message = ""


if cgi["email"] != cgi["email2"]
  error = 1
  message = "Eメールアドレスが確認用と一致しません。Email address does not match.<br />"
end
if cgi["lname"] == ""
  error = 1
  message = message + "姓が未入力です。Missing Last name.<br />"
end
if cgi["fname"] == ""
  error = 1
  message = message + "名が未入力です。 Missing First name.<br />"
end
if cgi["affil"] == ""
  error = 1
  message = message + "所属が未入力です。 Missing affiliation.<br />"
end
if cgi["email"] == ""
  error = 1
  message = message + "E-Mailがが未入力です。Missing E-Mail.<br />"
end
if cgi["email2"] == ""
  error = 1
  message = message + "E-Mail(確認用)が未入力です。Missing E-Mail confirmation<br />"
end
if cgi["status"] == ""
  error = 1
  message = message + "会員種別がチェックされていません。 Membership not selected.<br />"
end
        

if error == 0

print <<EOM
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

  form_text = <<EOM
   <input type="hidden" name="lname" value="#{cgi["lname"]}" />
   <input type="hidden" name="fname" value="#{cgi["fname"]}" />
   <input type="hidden" name="affil" value="#{cgi["affil"]}" />
   <input type="hidden" name="email" value="#{cgi["email"]}" />
   <input type="hidden" name="status" value="#{cgi["status"]}" />
   <input type="hidden" name="banquet" value="#{banquet}" />
EOM

  print <<EOM
<form action="./submit.rb" method="post" style="display: inline">
  #{form_text}
  <input type="submit" name="kakunin" value="上記の内容で申込む" />
</form>
<form action="./correction.rb" method="post" style="display: inline">
  #{form_text}
  <input type="submit" name="kakunin" value="修正する" />
</form>
EOM

else
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
  
  print <<EOM
      <h1>参加申込フォーム</h1>

      <p><span style="color: red">入力内容に誤りがあります!</span> <br />
        ご記入いただいた内容を再確認してください。<br />
        <span style="color: red">#{message}</span></p>

      <hr />
     <form action="./confirm.rb" method="post">
       <h2>お名前 Name</h2>
       <table>
 	<tr><th>姓 Last name</th><th>名 First & middle name</th></tr>
 	<tr>
 	  <td><input type="text" name="lname" value="#{cgi["lname"]}" size="20"/></td>
 	  <td><input type="text" name="fname" value="#{cgi["fname"]}"  size="20" /></td>
 	</tr>
 	<tr>
  	  <td class="ex">ex) 西郷; MOZART</td><td class="ex">ex) 隆盛; Wolfgang A.</td>
 	</tr>
       </table>
   
       <h2>ご所属 Affiliation</h2>
       <table>
 	<tr><td><input type="text" name="affil" value="#{cgi["affil"]}" size="90" /></td></tr>
 	<tr><td class="ex">例) 鹿児島大・理; 京都大・霊長研; Faculty of Sciences, Kagoshima Univ.; Primate Research Institute, Kyoto Univ.</td></tr>
       </table>
       <h2>電子メール E-Mail</h2>
       <table>
 	<tr><td><input type="text" name="email" value="#{cgi["email"]}" size="50" /></td></tr>
 	<tr><td><input type="text" name="email2" value="#{cgi["email2"]}" size="50" />(確認用 Confirmation)</td></tr>
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
     <p style="text-align: center;"><input type="submit" name="kakunin" value="確認画面へ進む" /></p>
   </form>
EOM
  
end
 
 
print <<EOM
</div>
</body>
</html>
EOM
