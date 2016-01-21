#!/usr/bin/ruby
# coding: utf-8
print "Content-Type: text/html\n\n"

require 'cgi'

cgi = CGI.new

authors = cgi["lname"] + cgi["fname"] + "（" + cgi["affil"] + "）"
authorsEn = cgi["fname-en"] + " " + cgi["lname-en"]

numauthors = cgi["co-author"].to_i
if numauthors > 1 then
  num = 1
  while num < numauthors do
    num = num + 1
    if cgi["author" + num.to_s] == ""
      break
    else
    authors = authors + "，" + cgi["author" + num.to_s] + "（" + cgi["affil" + num.to_s] + "）"
    authorsEn = authorsEn + ", " + cgi["author-en" + num.to_s]
    end
  end
end
    
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
    <h1>発表申込み：申込内容の確認</h1>
    <p>以下の内容でよろしいでしょうか。</p>
    <hr />

<h2>演題 Title</h2>
<table>
<tr><th>和文</th><td>#{cgi["title"]}</td></tr>
<tr><th>English Title</th><td>#{cgi["title-en"]}</td></tr>
</table>

<h2>発表者 Author(s)</h2>
<table>
<tr><th>和文</th><td>#{authors}</td></tr>
<tr><th>English</th><td>#{authorsEn}</td></tr>
</table>

<h2>要旨 Abstract</h2>

<pre>#{cgi["abstract"]}</pre>

<h2>発表種別 Category</h2>
<p>#{cgi["cat"]}</p>

<h2>発表賞 Student Award</h2>

<p>#{cgi["award"]}</p>

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
   <input type="hidden" name="authors" value="#{authors}" />
   <input type="hidden" name="authors-en" value="#{authorsEn}" />
   <input type="hidden" name="abstract" value="#{cgi["abstract"]}" />
   <input type="hidden" name="award" value="#{cgi["award"]}" />
EOM

if numauthors > 1 then
  num = 1
  while num < numauthors do
    num = num + 1
    form_text = form_text + '<input type="hidden" name = "author' + num.to_s + '" value = "' + cgi["author" + num.to_s] + '" />' + "\n"
    form_text = form_text + '<input type="hidden" name = "author-en' + num.to_s + '" value = "' + cgi["author-en" + num.to_s] + '" />' + "\n"
    form_text = form_text + '<input type="hidden" name = "affil' + num.to_s + '" value = "' + cgi["affil" + num.to_s] + '" />' + "\n"
  end
end



print <<EOM
<form action="./send-abstract.rb" method="post" style="display: inline">
  #{form_text}
  <input type="submit" name="kakunin" value="この内容で送信する" />
</form>
<form action="./correction-abstract.rb" method="post" style="display: inline">
  #{form_text}
  <input type="submit" name="kakunin" value="修正する" />
</form>
</div>
</body>
</html>
EOM

