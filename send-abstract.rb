#!/usr/bin/ruby
# coding: utf-8
print "Content-Type: text/html\n\n"

require 'cgi'
require 'mail'
require 'mail-iso-2022-jp'

cgi = CGI.new

ref = Time.now.strftime("%m%d%H%M%S") + "." + (("a".."z").to_a + ("A".."Z").to_a + (0..9).to_a).shuffle[0..1].join

input = <<EOM
演題: #{cgi["title"]}
発表者: #{cgi["authors"]}
英文演題: #{cgi["title-en"]}
発表者(欧文): #{cgi["authors-en"]}
種別: #{cgi["cat"]}
発表賞: #{cgi["award"]}
<要旨>
#{cgi["abstract"]}
EOM

submit = Mail.new(:charset => 'ISO-2022-JP')
submit.from = "#{cgi["lname"]} #{cgi["fname"]} <#{cgi["email"]}>" 
submit.to = "registration@psj32.com" 
submit.subject = "発表申込:#{ref}  #{cgi["lname"]} #{cgi["fname"]}様" 
submit.body = <<EOM
以下の内容で第32回日本霊長類学会の発表を申込みます。

***
受付番号: #{ref}
筆頭者氏名: #{cgi["lname"]} #{cgi["fname"]}
(欧文): #{cgi["lname-en"]} #{cgi["fname-en"]}
電子メール: #{cgi["email"]}
#{input}
***
EOM

submit.deliver

subscriber = Mail.new(:charset => 'ISO-2022-JP')
subscriber.from = "第32回日本霊長類学会大会事務局 <info@psj32.com>" 
subscriber.to = "#{cgi["lname"]} #{cgi["fname"]}様 <#{cgi["email"]}>" 
subscriber.subject = "第32回日本霊長類学会大会 発表申込完了" 
subscriber.body = <<EOM
 #{cgi["lname"]} #{cgi["fname"]}様

#このメールはシステムからの自動送信メールです。
#以下の内容に覚えがなければ、無視するか、info@psj32.comへご連絡ください。

 以下の内容で第32回日本霊長類学会の発表申込を受け付けました。
 のちほど、担当者より確認のメールをお送りします。


受付番号: #{ref}
#{input}

 一週間たっても担当者からメールが届かない場合や、お申込み内容に修正がありましたら、info@psj32.com へご連絡ください。

当日、#{cgi["lname"]}様にお会いできますことを楽しみにしております。

---
第32回日本霊長類学会事務局
info@psj32.com
http://www.psj32.com

EOM

subscriber.deliver


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
    <h1>発表申込み完了</h1>
    <p>下記の内容で発表申込みが完了しました。<br />
       受付番号は <span style="font-style: bold; color: blue">#{ref}</span> です。<br />
       ご登録のメールアドレス宛に同じ内容をメールしましたので、ご確認ください。
       のちほど、担当者より確認のメールを差し上げます。
       一週間たっても担当者からメールが届かない場合は、info@psj32.comまでご連絡ください。</p>
    <hr />
EOM

print <<EOM
<h2>演題 Title</h2>
<p>#{cgi["title"]}</p>
<p>#{cgi["title-en"]}</p>

<h2>発表者</h2>
<p>#{cgi["authors"]}</p>
<p>#{cgi["authors-en"]}</p>

<h2>種別 Category</h2>
<p>#{cgi["cat"]}</p>

<h2>発表賞</h2>
<p>#{cgi["award"]}</p>

<h2>要旨 Abstract</h2>
<pre>#{cgi["abstract"]}</pre>


EOM

print <<EOM
<p><a href="http://www.psj32.com/">トップページに戻る</a></p>
</div>
</body>
</html>
EOM


