#!/usr/bin/ruby
# coding: utf-8
print "Content-Type: text/html\n\n"

require 'cgi'
require 'mail'
require 'mail-iso-2022-jp'

cgi = CGI.new

ref = Time.now.strftime("%m%d%H%M%S") + "-" + (("a".."z").to_a + ("A".."Z").to_a + (0..9).to_a).shuffle[0..1].join

input = <<EOM
演題 Original Title: #{cgi["title"]}
発表者 Author(s): #{cgi["authors"]}
英文演題 English Title: #{cgi["title-en"]}
発表者(欧文) Author(s): #{cgi["authorsEn"]}
種別 Category: #{cgi["cat"]}
発表賞 Presentaion Award: #{cgi["award"]}
<要旨 Abstract>
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
    <li id="lname">#{cgi["name"]}</li>
    <li id="affil">#{cgi["affil"]}</li>
    <li id="email">#{cgi["email"]}</li>
    <li id="title">#{cgi["title"]}</li>
    <li id="title-e">#{cgi["title-en"]}</li>
    <li id="authors">#{cgi["authors"]}</li>
    <li id="authors-e">#{cgi["authorsEn"]}</li>
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
subscriber.to = "#{cgi["name"]}様 <#{cgi["email"]}>"
subscriber.cc = "registration@psj32.com" 
subscriber.subject = "[PSJ32] Abstract received PSJ32発表申込完了" 
subscriber.body = <<EOM
 #{cgi["name"]}様 Dear #{cgi["name"]}

#このメールはシステムからの自動送信メールです。
#以下の内容に覚えがなければ、無視するか、registration@psj32.comへご連絡ください。
# This is an automatically generated e-mail for registration confirmation.

以下の内容で第32回日本霊長類学会の発表申込を受け付けました。
Your Abstract submission is sent to PSJ32 exective office.

のちほど、担当者より確認のメールをお送りします。
The person in charge will send you a confirmation message later.

受付番号: #{ref}
#{input}

一週間たっても担当者からメールが届かない場合や、お申込み内容に修正がありましたら、registration@psj32.com へご連絡ください。
If you may not receive the confirmation message within one week, please contact us via registration@psj32.com. 

当日お会いできますことを楽しみにしております。
We are looking forward to see you in Kagoshima!

---
第32回日本霊長類学会事務局
PSJ32 Exective Office
info@psj32.com
http://www.psj32.com
EOM

subscriber.deliver

print File.read('head-common.html')

print <<EOM
    <h1>発表申込み完了</h1>
    <p>下記の内容で発表申込みが完了しました。Your Abstract submission is sent to PSJ32 exective office.<br />
       受付番号は <span style="font-style: bold; color: blue">#{ref}</span> です。<br />
       Your reference is <span style="font-style: bold; color: blue">#{ref}</span>. <br />
       ご登録のメールアドレス宛に同じ内容をメールしましたので、ご確認ください。<br />
       An automatically generated message is sent to your e-mail address.
       のちほど、担当者より確認のメールを差し上げます。<br />
       Later, the person in charge will send you a confirmation message to your e-mail address.<br />
       一週間たっても担当者からメールが届かない場合は、<a href="mailto:registration@psj32.com">registration@psj32.com</a>までご連絡ください。<br />
       If you may not receive the confirmation message within one week, please contact us via <a href="mailto:registration@psj32.com">registration@psj32.com</a></p>
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
<p><a href="http://www.psj32.com/">大会トップページに戻る Back to Home</a></p>

EOM

print File.read('foot-common.html')


