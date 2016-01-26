#!/usr/bin/ruby
# coding: utf-8
print "Content-Type: text/html\n\n"

require 'cgi'
require 'mail'
require 'mail-iso-2022-jp'

cgi = CGI.new

ref = Time.now.strftime("%m%d%H%M%S") + "-" + (("a".."z").to_a + ("A".."Z").to_a + (0..9).to_a).shuffle[0..1].join

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

htmlsource = <<EOM
<html>
<head>
</head>
<body>
<div id="main">

<h1>発表申込情報: #{ref}</h1>

<div id="subscriber">
  <ul>
    <li id="ref"> #{ref}</li>
    <li id="lname">#{cgi["lname"]}</li>
    <li id="fname">#{cgi["fname"]}</li>
    <li id="affil">#{cgi["affil"]}</li>
    <li id="email">#{cgi["email"]}</li>
    <li id="title">#{cgi["title"]}</li>
    <li id="title-e">#{cgi["title-en"]}</li>
    <li id="authors">#{cgi["authors"]}</li>
    <li id="authors-e">#{cgi["authors-en"]}</li>
    <li id="cat">#{cgi["cat"]}</li>
    <li id="award">#{cgi["award"]}</li>
  </ul>
</div>

<hr />

<div id="abstract">
  <h1 id="abst-title" style="font-family: sans-serif">#{cgi["title"]}</h1>
  <h1 id="abst-title-e" style="font-family: sans-serif">#{cgi["title-en"]}</h1>
  <h2 id="abst-authors">#{cgi["authors"]}</h2>
  <h2 id="abst-authors-e">#{cgi["authors-en"]}</h2>
  <p id="abstract">#{cgi["abstract"]}</p>
</div>
</body>
</html>
EOM


attach = File.open("/tmp/form/#{ref}.html", "a")
attach.write(htmlsource)
attach.close

submit = Mail.new(:charset => 'ISO-2022-JP')
submit.from = "#{cgi["lname"]} #{cgi["fname"]} <#{cgi["email"]}>" 
submit.to = "registration@psj32.com" 
submit.subject = "[PSJ32:html]発表申込:#{ref}  #{cgi["lname"]} #{cgi["fname"]}様" 
submit.body = <<EOM
PSJ32 server received a new subscription of a paper.
See the attachement for detail.
EOM
submit.add_file("/tmp/form/#{ref}.html")

submit.deliver
system("rm /tmp/form/#{ref}.html")

subscriber = Mail.new(:charset => 'ISO-2022-JP')
subscriber.from = "第32回日本霊長類学会大会事務局 <info@psj32.com>" 
subscriber.to = "#{cgi["lname"]} #{cgi["fname"]}様 <#{cgi["email"]}>"
subscriber.cc = "registration@psj32.com" 
subscriber.subject = "[PSJ32] 第32回日本霊長類学会大会 発表申込完了" 
subscriber.body = <<EOM
 #{cgi["lname"]} #{cgi["fname"]}様

#このメールはシステムからの自動送信メールです。
#以下の内容に覚えがなければ、無視するか、registration@psj32.comへご連絡ください。

以下の内容で第32回日本霊長類学会の発表申込を受け付けました。
のちほど、担当者より確認のメールをお送りします。

受付番号: #{ref}
#{input}

 一週間たっても担当者からメールが届かない場合や、お申込み内容に修正がありましたら、registration@psj32.com へご連絡ください。

当日、#{cgi["lname"]}様にお会いできますことを楽しみにしております。

---
第32回日本霊長類学会事務局
info@psj32.com
http://www.psj32.com
EOM

subscriber.deliver

print File.read('head-common.html')

print <<EOM
    <h1>発表申込み完了</h1>
    <p>下記の内容で発表申込みが完了しました。<br />
       受付番号は <span style="font-style: bold; color: blue">#{ref}</span> です。<br />
       ご登録のメールアドレス宛に同じ内容をメールしましたので、ご確認ください。
       のちほど、担当者より確認のメールを差し上げます。
       一週間たっても担当者からメールが届かない場合は、registration@psj32.comまでご連絡ください。</p>
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
<p>#{cgi["abstract"]}</p>

<hr />
<p><a href="http://www.psj32.com/">大会トップページに戻る</a></p>

EOM

print File.read('foot-common.html')


