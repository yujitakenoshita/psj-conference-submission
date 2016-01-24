#!/usr/bin/ruby
# coding: utf-8
print "Content-Type: text/html\n\n"

require 'cgi'

cgi = CGI.new

authorinfo = <<EOM
   <input type="hidden" name="lname" value="#{cgi["lname"]}" />
   <input type="hidden" name="fname" value="#{cgi["fname"]}" />
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
    <h1>発表申込み：要旨と発表者</h1>
    <p>続いて、以下に発表要旨と発表者情報を記入して下さい。</p>
    <hr />

<form action="./confirm-abstract.rb" method="post">
 #{authorinfo}
<h2>発表要旨 Abstract</h2>
<p><span style="font-size: 80%">800字程度で要旨を入力してください
Abstract should be less than about 350 words.<br />
太字にしたい文字は &lt;b&gt;&lt/b&gt;で、イタリック体にしたい文字は&lt;i&gt;&lt/i&gt;で挟んでください。(例: &lt;b&gt;太字/Bold&lt/b&gt;; &lt;i&gt;イタリック/Italic&lt/i&gt;<br />
If you want to use <b>bold</b> or <i>italic</i> text, enclose the text with  &lt;b&gt;&lt/b&gt; and  &lt;b&gt;&lt/b&gt;.<br />
(example: &lt;b&gt;<b>太字/Bold</b>&lt/b&gt;; &lt;i&gt;<i>イタリック/Italic</i>&lt/i&gt;</p>
<p><textarea name="abstract" wrap="virtual" cols=82 rows=20></textarea></p>
EOM

print <<EOM
<h2>発表者</h2>
<p>発表者の情報を以下に入力してください。<br />
和文のお名前は、姓と名のあいだに半角スペースを入れてください。(例) 西郷 隆盛<br />
欧文のお名前は、姓を先に、名をうしろに記してください。姓はすべて大文字にしてください。(例) MOZART Wolfgang A <br />
For English name, last name should be capitalized and placed first. (ex) MOZART Wolfgang A</p>
<fieldset>
<legend>筆頭発表者</legend>
<p><span style="font-size: 60%">氏名 (和文/Japanese)</span><input type="text" name="author1" value="#{cgi["lname"]} #{cgi["fname"]}" size="25"> 
   <span style="font-size: 60%">例) 西郷 隆盛; MOZART Worfgang A</span><br />
<span style="font-size: 60%;">　　　　 (欧文/English)</span><input type="text" name="author-en1" value="" size="40"> <span style="font-size: 60%"> ex) SAIGO Takamori; MOZART Wolfgang A</span><br />
<span style="font-size: 60%; color: red">Please fill both Japanese and English fields.</span>
<p><span style="font-size: 60%">所属　　</span><input type="text" name="affil1" value="#{cgi["affil"]}" size="60"></p>
</fieldset>
EOM


if cgi["co-author"].to_i >= 2 then
    num = 1
    while num < cgi["co-author"].to_i do
      num = num + 1
      print <<EOM
<fieldset>\n
<legend>第#{num}発表者</legend>\n
<p><span style="font-size: 60%;">氏名 Name (和文/Japanese)</span><input type="text" name="author#{num}" value="" size="20"> <span style="font-size: 60%">例)大久保 利通; HAYDN Franz J</span><br />
<span style="font-size: 60%;">　　　　 (欧文/English)</span><input type="text" name="author-en#{num}" value="" size="40"> <span style="font-size: 60%"> ex) OHKUBO Toshimichi; HAYDN Franz J</span><br />
<span style="font-size: 60%; color: red">Please fill both Japanese and English fields.</span>
</p>
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
