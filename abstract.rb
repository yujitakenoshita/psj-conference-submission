#!/usr/bin/ruby
# coding: utf-8
print "Content-Type: text/html\n\n"

require 'cgi'

cgi = CGI.new

authorinfo = <<EOM
   <input type="hidden" name="lname" value="#{cgi["lname"]}" />
   <input type="hidden" name="fname" value="#{cgi["fname"]}" />
   <input type="hidden" name="lname-en" value="#{cgi["lname-en"]}" />
   <input type="hidden" name="fname-en" value="#{cgi["fname-en"]}" />
   <input type="hidden" name="affil" value="#{cgi["affil"]}" />
   <input type="hidden" name="email" value="#{cgi["email"]}" />
   <input type="hidden" name="cat" value="#{cgi["cat"]}" />
   <input type="hidden" name="title" value="#{cgi["title"]}" />
   <input type="hidden" name="title-en" value="#{cgi["title-en"]}" />
   <input type="hidden" name="co-author" value="#{cgi["co-author"]}" />
   <input type="hidden" name="award" value="#{cgi["award"]}" />
EOM

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
    <h1>発表申込み：要旨と共同発表者</h1>
    <p>続いて、以下に発表要旨を記入して下さい。
       共同発表者がいる場合は、共同発表者の氏名と所属(和文のみ)を記入してください。</p>
    <hr />

<form action="./confirm-abstract.rb" method="post">
 #{authorinfo}
<h2>発表要旨 Abstract</h2>
<p><textarea name="abstract" wrap="physical" cols=80 rows=11>
(800字程度で要旨を入力してください)</textarea></p>
EOM

if cgi["co-author"].to_i >= 2 then
    print "<h2>共同発表者 Co-author(s)</h2>\n"
    print "<p>申込者以外の共同発表者の情報を以下に入力してください。</p>\n"
    num = 1
    while num < cgi["co-author"].to_i do
      num = num + 1
      print <<EOM
<fieldset>\n
<legend>第#{num}発表者</legend>\n
<p><span style="font-size: 60%;">氏名 (和文)</span><input type="text" name="author#{num}" value="" size="20"> <span style="font-size: 60%">例)犬山太郎</span><br />
<span style="font-size: 60%;">　　 (欧文)</span><input type="text" name="author-en#{num}" value="" size="40"> <span style="font-size: 60%"> ex) Walfgang A. Mozart</span></p>
<p><span style="font-size: 60%">所属   　　</span><input type="text" name="affil#{num}" value="" size="60"></p>
</fieldset>
EOM
    end
end

print <<EOM
<p style="text-align: center"><input type="submit" name="kakunin" value="確認する" /></p>
</form>
</div>
</body>
</html>
EOM
