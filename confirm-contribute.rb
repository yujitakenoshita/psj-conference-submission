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

<table>
<tr><th>お名前</th><td>#{cgi["lname"]} #{cgi["fname"]}</td></tr>
<tr><th>お名前(欧文)</th><td>#{cgi["lname-en"]} #{cgi["fname-en"]}</td></tr>
<tr><th>ご所属</th><td>#{cgi["affil"]}</td></tr>
<tr><th>電子メール</th><td>#{cgi["email"]}</td></tr>
<tr><th>発表種別</th><td>#{cgi["cat"]}</td></tr>
<tr><th>演題</th><td>#{cgi["title"]}</td></tr>
<tr><th>演題(欧文)</th><td>#{cgi["title-en"]}</td></tr>
<tr><th>共同発表者数</th><td>#{cgi["co-author"]}人</td></tr>
<tr><th>発表賞</th><td>#{cgi["award"]}</td></tr>
</table>
EOM

form_text = <<EOM
   <input type="hidden" name="lname" value="#{cgi["lname"]}" />
   <input type="hidden" name="fname" value="#{cgi["fname"]}" />
   <input type="hidden" name="lname-en" value="#{cgi["lname-en"]}" />
   <input type="hidden" name="fname-en" value="#{cgi["fname-en"]}" />
   <input type="hidden" name="affil" value="#{cgi["affil"]}" />
   <input type="hidden" name="affil-en" value="#{cgi["affil-en"]}" />
   <input type="hidden" name="email" value="#{cgi["email"]}" />
   <input type="hidden" name="cat" value="#{cgi["cat"]}" />
   <input type="hidden" name="title" value="#{cgi["title"]}" />
   <input type="hidden" name="title-en" value="#{cgi["title-en"]}" />
   <input type="hidden" name="co-author" value="#{cgi["co-author"]}" />
   <input type="hidden" name="award" value="#{cgi["award"]}" />
EOM

print <<EOM
<form action="./abstract.rb" method="post" style="display: inline">
  #{form_text}
  <input type="submit" name="kakunin" value="要旨と共同発表者の入力に進む" />
</form>
<form action="./correction-contribute.rb" method="post" style="display: inline">
  #{form_text}
  <input type="submit" name="kakunin" value="修正する" />
</form>
</div>
</body>
</html>
EOM
