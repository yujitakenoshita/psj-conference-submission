#!/usr/bin/ruby
# coding: utf-8
print "Content-Type: text/html\n\n"

require 'cgi'
require 'net/smtp'


# 受付番号の生成：現在日時に3桁の乱数を追加
ref = Time.now.strftime("%m%d%H%M%S") + '.' + (rand * 1000).round.to_s

# フォーム (paritipate.html) から値を取得する
# 取得項目
# 必須項目：性 (lname) text
#           名 (fname) text
#           メアド (email) text
#           メアド確認用 (email2) text
#           電話番号 (tel) text
#           所属 (affil) text
#           会員かどうか (mship) radio
#           一般・学生等の別 (status) radio
# 自由項目：懇親会に参加するか (banquet) check
#           託児を利用するか (takuji) check
#           託児人数 (takuji-n) text
#           特記事項 (request) textarea
cgi = CGI.new


# 担当者にメール
user_from = "yujitake@ape.chubu-gu.ac.jp"
user_to = "#{cgi["email"]}"

the_email = "From: yujitake@ape.chubu-gu.ac.jp\n" +
            "To: #{cgi["email"]}\n" +
            "Subject: PSJ32への参加申込通知 [#{ref}]\n\n" +
            "以下の内容で、PSJ32への参加申込がありました。\n\n" +
            "---登録内容、ここから---\n" +
            "受付番号: #{ref} \n" +
            "姓: #{cgi["lname"]} \n" +
            "名: #{cgi["fname"]} \n" +
            "所属: #{cgi["affil"]}\n" +
            "メール: #{cgi["email"]}\n" +
            "Tel: #{cgi["tel"]}\n" +
            "資格: #{cgi["kaiin"]}\n" +
            "身分: #{cgi["status"]}\n" +
            "懇親会: #{cgi["banquet"]}\n" +
            "託児: #{cgi["takuji"]} \n" +
            "託児人数: #{cgi["takuji-n"]} \n" +
            "特記事項:\n" +
            "#{cgi["request"]}\n\n" +
            "---登録内容おわり---\n" 

# メール送信
begin
  Net::SMTP.start('localhost') do |smtp|
    smtp.send_message(the_email, user_from, user_to)
  end

rescue Exception => e
  print "Exception occured: " + e
end


print <<EOM
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>申込完了</title>
</head>
<body>
<h1>参加申込完了 (#{ref})</h1>
<p>#{cgi["lname"]} #{cgi["fname"]}さんの参加申込を受付ました。
受付番号は #{ref} です。</p>
<p>登録内容は以下の通りです。</p>
<p>登録したメールアドレス宛に、受付完了メールを送信します。
しばらくしてもメールが届かない場合は、<a href="mailto:info@psj32.com">info@psj32.com</a>までご連絡ください。</p>

<table>
<tr><th>受付番号</th><td>#{ref}</td></tr>
<tr><th>氏名</th><td>#{cgi["lname"]} #{cgi["fname"]}</td></tr>
<tr><th>所属</th><td>#{cgi["affil"]}</td></tr>
<tr><th>メール</th><td>#{cgi["email"]}</td></tr>
<tr><th>Tel</th><td>#{cgi["tel"]}</td></tr>
<tr><th>資格</th><td>#{cgi["kaiin"]}</td></tr>
<tr><th>身分</th><td>#{cgi["status"]}</td></tr>
<tr><th>懇親会</th><td>#{cgi["banquet"]}</td></tr>
<tr><th>託児</th><td>#{cgi["takuji"]} (#{cgi["takuji-n"]}人)</td></tr>
<tr><th>特記事項</th><td>#{cgi["request"]}</td></tr>
</table>
</body>
</html>
EOM

# 申込者にメール
user_from = "yujitake@ape.chubu-gu.ac.jp"
user_to = "#{cgi["email"]}"

the_email = "From: yujitake@ape.chubu-gu.ac.jp\n" +
            "To: #{cgi["email"]}\n" +
            "Subject: #{cgi["lname"]} #{cgi["fname"]}さんからのPSJ32への参加申込を受けつけました [#{ref}]\n\n" +
            "#{cgi["lname"]} #{cgi["fname"]} 様、\n\n" +
            "日本霊長類学会第32回大会事務局です。\n" +
            "このたびは、大会への参加申込、ありがとうございます。\n\n" +
            "以下の内容で、参加登録いたしました。\n\n" +
            "修正事項がありましたら、受付番号と氏名を明記して、info@psj32.com までご連絡ください。" +
            "ご連絡の際は、件名を「PSJ32参加登録についての問い合わせ #{ref}」としてください。\n\n" +
            "なお、このメールにお心あたりのない場合も、ご面倒ですが同様に info@psj32.com までご連絡くださるとたすかります。\n\n" +
            "(このメールは自動送信システムを利用していますので、普通に返信しても連絡はできません。)\n\n" +
            "---登録内容、ここから---\n" +
            "受付番号: #{ref} \n" +
            "氏名: #{cgi["lname"]} #{cgi["fname"]} \n" +
            "所属: #{cgi["affil"]}\n" +
            "メール: #{cgi["email"]}\n" +
            "Tel: #{cgi["tel"]}\n" +
            "資格: #{cgi["kaiin"]}\n" +
            "身分: #{cgi["status"]}\n" +
            "懇親会: #{cgi["banquet"]}\n" +
            "託児: #{cgi["takuji"]} (#{cgi["takuji-n"]}人)\n" +
            "特記事項:\n" +
	    "#{cgi["request"]}\n\n" +
            "---登録内容おわり---\n" 


# handling exceptions
begin
  Net::SMTP.start('localhost') do |smtp|
    smtp.send_message(the_email, user_from, user_to)
  end

rescue Exception => e
  print "Exception occured: " + e
end

