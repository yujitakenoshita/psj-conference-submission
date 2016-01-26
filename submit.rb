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

  banquet = ""
  if cgi["banquet"] != "" then
    banquet = "参加 Attend"
  else
    banquet = "未入力 blank"
  end
  
  input = <<EOM
お名前 Name: #{cgi["name"]}
ご所属 Affiliation: #{cgi["affil"]}
電子メールE-Mail: #{cgi["email"]}
会員種別 PSJ membership: #{cgi["status"]}
懇親会 Banquet: #{banquet}
EOM

  csvline = "#{cgi["name"]},#{cgi["affil"]},#{cgi["email"]},#{cgi["status"]},#{banquet}"

  submit = Mail.new(:charset => 'ISO-2022-JP')
  submit.from = "#{cgi["email"]}" 
  submit.to = "info@psj32.com" 
  submit.subject = "[PSJ32] 参加申込 #{cgi["name"]}"
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
http://www.psj32.com/cgi-bin/contribution.rb?name=#{cgi["name"]}&affil=#{cgi["affil"]}&email=#{cgi["email"]}
EOM
  
  subscriber = Mail.new(:charset => 'ISO-2022-JP')
  subscriber.from = "第32回日本霊長類学会大会事務局 <info@psj32.com>" 
  subscriber.to = "#{cgi["name"]}様 <#{cgi["email"]}>" 
  subscriber.subject = "PSJ32 registration complete. PSJ32参加申込完了" 
  subscriber.body = <<EOM
 #{cgi["name"]}様

# このメールはシステムからの自動送信メールです。
# 以下の内容に覚えがなければ、無視するか、info@psj32.comへご連絡ください。
# This is an automatically generated e-mail for registration confirmation.

 以下の内容で第32回日本霊長類学会の参加申込を受け付けました。
 We've received your registration to PSJ32.
 
#{input}

お申込み内容に修正がありましたら、info@psj32.com へご連絡ください。
If you have any inquires or problems, please contact via info@psj32.com

発表申込をされる方は、以下のURLから申込みしてください。
If you want to submit a presentation, follow the URI below.

#{URI.escape(subscribeurl)}

当日お会いできますことを楽しみにしております。
We are looking forward to see you in Kagoshima!

---
第32回日本霊長類学会事務局
PSJ32 Exective Committee
info@psj32.com
http://www.psj32.com

EOM

  subscriber.deliver
  
  print File.read('head-common.html')
  
  print <<EOM
  <h1>参加申込完了</h1>
  <p>下記の内容で参加申込が完了しました。
     ご登録のアドレスに確認メールをお送りしました。<br />
     Your registration is successfully sent to the PSJ32 exective office.
     A confirmation message is sent to your e-mail address.
     続けて発表申込みをされる方は、「発表申込みをする」ボタンをクリックしてください。<br />
     You may proceed to presentation submission via "Submit your presentation" button. <br />
     あとで発表申込みをされる方は、確認メールに記載の発表申込み用URLからお申込みください。<br />
     Or you may submit your presentation later via the URL in the confirmation message.</p>
  <hr />
<table>
<tr><th>お名前 Name</th></tr>
<tr><td>#{cgi["name"]}</td></tr>
<tr><th>ご所属 Affiliation</th></tr>
<tr><td>#{cgi["affil"]}</td></tr>
<tr><th>電子メール E-Mail</th></tr>
<tr><td>#{cgi["email"]}</td></tr>
<tr><th>会員種別 PSJ membership</th></tr>
<tr><td>#{cgi["status"]}</td></tr>
<tr><th>懇親会 Banquet</th></tr>
<tr><td>#{banquet}</td></tr>
</table>

<form action="./contribution.rb" method="get">
   <input type="hidden" name="name" value="#{cgi["name"]}" />
   <input type="hidden" name="affil" value="#{cgi["affil"]}" />
   <input type="hidden" name="email" value="#{cgi["email"]}" />
  <input type="submit" name="kakunin" value="発表申込みをする Submit Presentation" />
<input type="button" value="トップページに戻る Back to Toppage" onClick="window.open('http://www.psj32.com/')">
EOM

  print File.read('foot-common.html')

rescue
  error_cgi
end
