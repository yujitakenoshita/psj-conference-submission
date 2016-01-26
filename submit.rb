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

  require 'url'
  require 'cgi'
  require 'mail'
  require 'mail-iso-2022-jp'

  cgi = CGI.new

  input = <<EOM
お名前: #{cgi["lname"]} #{cgi["fname"]}
ご所属: #{cgi["affil"]}
電子メール: #{cgi["email"]}
会員種別: #{cgi["status"]}
懇親会: #{cgi["banquet"]}
EOM

  csvline = "#{cgi["lname"]},#{cgi["fname"]},#{cgi["affil"]},#{cgi["email"]},#{cgi["status"]},#{cgi["banquet"]}"

  submit = Mail.new(:charset => 'ISO-2022-JP')
  submit.from = "#{cgi["email"]}" 
  submit.to = "info@psj32.com" 
  submit.subject = "[PSJ32] 参加申込 #{cgi["lname"]} #{cgi["fname"]}" 
  submit.body = <<EOM
 以下の内容で第32回日本霊長類学会に参加申込します。
*** 
#{input}
***

---事務局使用欄---
#{csvline}
------------------
EOM
  
  submit.deliver
  
  subscribeurl = <<EOM
http://www.psj32.com/cgi-bin/contribution.rb?lname=#{cgi["lname"]}&fname=#{cgi["fname"]}&affil=#{cgi["affil"]}&email=#{cgi["email"]}
EOM
  
  subscriber = Mail.new(:charset => 'ISO-2022-JP')
  subscriber.from = "第32回日本霊長類学会大会事務局 <info@psj32.com>" 
  subscriber.to = "#{cgi["lname"]} #{cgi["fname"]}様 <#{cgi["email"]}>" 
  subscriber.subject = "第32回日本霊長類学会大会 参加申込完了" 
  subscriber.body = <<EOM
 #{cgi["lname"]} #{cgi["fname"]}様

# このメールはシステムからの自動送信メールです。
# 以下の内容に覚えがなければ、無視するか、info@psj32.comへご連絡ください。

 以下の内容で第32回日本霊長類学会の参加申込を受け付けました。
 
#{input}

お申込み内容に修正がありましたら、info@psj32.com へご連絡ください。

発表申込をされる方は、以下のURLから申込みしてください。

#{URI.escape(subscribeurl)}

当日、#{cgi["lname"]}様にお会いできますことを楽しみにしております。

---
第32回日本霊長類学会事務局
info@psj32.com
http://www.psj32.com

EOM

  subscriber.deliver
  
  print File.read('head-common.html')
  
  print <<EOM
  <h1>参加申込完了</h1>
  <p>下記の内容で参加申込が完了しました。
     ご登録のアドレスに確認メールをお送りしました。<br />
     続けて発表申込みをされる方は、「発表申込みをする」ボタンをクリックしてください。<br />
     あとで発表申込みをされる方は、確認メールに記載の発表申込み用URLからお申込みください。</p>
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
<tr><td>#{cgi["banquet"]}</td></tr>
</table>

<form action="./contribution.rb" method="get">
   <input type="hidden" name="lname" value="#{cgi["lname"]}" />
   <input type="hidden" name="fname" value="#{cgi["fname"]}" />
   <input type="hidden" name="affil" value="#{cgi["affil"]}" />
   <input type="hidden" name="email" value="#{cgi["email"]}" />
  <input type="submit" name="kakunin" value="発表申込みをする" />
<input type="button" value="トップページに戻る" onClick="window.open('http://www.psj32.com/')">
EOM

  print File.read('foot-common.html')

rescue
  error_cgi
end
