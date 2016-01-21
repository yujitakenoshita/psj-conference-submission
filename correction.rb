#!/usr/bin/ruby
# coding: utf-8
print "Content-Type: text/html\n\n"

require 'cgi'

cgi = CGI.new

if cgi["status"] == "一般"
  full = "checked"
  student = ""
elsif cgi["status"] == "学生"
  full = ""
  full = "checked"
end

if cgi["banquet"] == "参加する"
  banquet = "checked"
else
  banquet = ""
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
    <h1>参加申込フォーム</h1>

    <p>参加される会員の方は、必ず参加申込をしてください。
      発表申込は、参加申込にひきつづいて行ないます。
      発表予定の方は、発表申込に必要な情報をご用意のうえ、参加申込をおこなってください。</p>

    <hr />
    
    <form action="./confirm.rb" method="post">
      <h2>お名前 Name</h2>
      <table>
	<tr><th></th><th>姓</th><th>名</th><th></th><th>Last Name</th><th>First and middle name</th></tr>
	<tr>
	  <td>和文</td>
	  <td><input type="text" name="lname" value="#{cgi["lname"]}" size="15"/></td>
	  <td><input type="text" name="fname" value="#{cgi["fname"]}"  size="15" /></td>
	  <td>欧文</td>
	  <td><input type="text" name="lname-en" value="#{cgi["lname-en"]}"  size="20"/></td>
	  <td><input type="text" name="fname-en" value="#{cgi["fname-en"]}" size="20" /></td>
	</tr>
	<tr>
	  <td></td><td></td><td></td><td></td>
	  <td class="ex">ex) Mozart</td><td class="ex">ex) Wolfgang A.</td>
	</tr>
      </table>
      
      <h2>ご所属 Affiliation</h2>
      <table>
	<tr><td><input type="text" name="affil" value="#{cgi["affil"]}" size="90" /></td></tr>
	<tr><td class="ex">例) 鹿児島大・理; 京都大・霊長研 | Faculty of Sciences, Kagoshima Univ.; Primate Research Institute, Kyoto Univ.</td></tr>
      </table>

      <h2>電子メール E-Mail</h2>
      <table>
	<tr><td><input type="text" name="email" value="#{cgi["email"]}" size="50" /></td></tr>
	<tr><td><input type="text" name="email2" value="#{cgi["email"]}" size="50" />(確認用 Confirmation)</td></tr>
     </table>

      <h2>会員種別 Membership</h2>
      <table>
	<tr><td><input type="radio" name="status" value="一般" #{full} />一般 Full
	    <input type="radio" name="status" value="学生" #{student} />学生 Student</td></tr>  
      </table>

      <h2>懇親会 Banquet</h2>
      <table>
      <tr><td><input type="checkbox" name="banquet" value="参加する" #{banquet} />参加する Attend</td></tr>
    </table>
    <p style="text-align: center;"><input type="submit" name="kakunin" value="確認画面へ進む" /></p>
  </form>
  </div>
</body>
</html>
EOM