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
  <h1>参加情報の確認</h1>
  <p>下記の内容で参加申込を行ないますか？
     入力内容をご確認のうえ、誤りがなければ「上記の内容で申込む」を、修正事項があれば「修正する」をクリックしてください。</p>
  <hr />
<table>
<tr><th>お名前</th></tr>
<tr><td>#{cgi["lname"]} #{cgi["fname"]} / #{cgi["lname-en"]} #{cgi["fname-en"]}</td></tr>
<tr><th>ご所属</th></tr>
<tr><td>#{cgi["affil"]}</td></tr>
<tr><th>電子メール</th></tr>
<tr><td>#{cgi["email"]}</td></tr>
<tr><th>会員種別</th></tr>
<tr><td>#{cgi["status"]}</td></tr>
<tr><th>懇親会</th></tr>
<tr><td>#{cgi["banquet"]}</td></tr>
</table>
EOM

form_text = <<EOM
   <input type="hidden" name="lname" value="#{cgi["lname"]}" />
   <input type="hidden" name="fname" value="#{cgi["fname"]}" />
   <input type="hidden" name="lname-en" value="#{cgi["lname-en"]}" />
   <input type="hidden" name="fname-en" value="#{cgi["fname-en"]}" />
   <input type="hidden" name="affil" value="#{cgi["affil"]}" />
   <input type="hidden" name="email" value="#{cgi["email"]}" />
   <input type="hidden" name="status" value="#{cgi["status"]}" />
   <input type="hidden" name="banquet" value="#{cgi["banquet"]}" />
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
</div>
</body>
</html>

EOM
