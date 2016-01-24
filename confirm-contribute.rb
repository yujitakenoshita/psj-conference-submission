#!/usr/bin/ruby
# coding: utf-8
print "Content-Type: text/html\n\n"

require 'cgi'

cgi = CGI.new

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
EOM

error = 0
message = ""

if cgi["lname"] == ""
  error = 1
  message = message + "姓が未入力です。Missing Last name.<br />"
end
if cgi["fname"] == ""
  error = 1
  message = message + "名が未入力です。 Missing First name.<br />"
end
if cgi["affil"] == ""
  error = 1
  message = message + "所属が未入力です。 Missing affiliation.<br />"
end
if cgi["email"] == ""
  error = 1
  message = message + "E-Mailが未入力です。Missing E-Mail.<br />"
end
if cgi["cat"] == ""
  error = 1
  message = message + "発表形式を選択してください。Please select category.<br />"
end
if cgi["title"] == ""
  error = 1
  message = message + "演題が未入力です。Missing title.<br />"
end
if cgi["title-en"] == ""
  error = 1
  message = message + "英文演題が未入力です。Missing English title.<br />"
end
if cgi["co-author"] == "0"
  error = 1
  message = message + "発表者数を選択してください。Please select number of author(s).<br />"
end

if error == 0

print <<EOM
<h2>発表申込者、演題の確認</h2>

<table>
<tr><th>お名前</th><td>#{cgi["lname"]} #{cgi["fname"]}</td></tr>
<tr><th>ご所属</th><td>#{cgi["affil"]}</td></tr>
<tr><th>電子メール</th><td>#{cgi["email"]}</td></tr>
<tr><th>発表種別</th><td>#{cgi["cat"]}</td></tr>
<tr><th>演題</th><td>#{cgi["title"]}</td></tr>
<tr><th>演題(欧文)</th><td>#{cgi["title-en"]}</td></tr>
<tr><th>共同発表者数</th><td>#{cgi["co-author"]}人</td></tr>
<tr><th>発表賞</th><td>#{cgi["award"]}</td></tr>
</table>
EOM

form_text = <<EOM
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
<form action="./abstract.rb" method="post" style="display: inline">
  #{form_text}
  <input type="submit" name="kakunin" value="要旨と共同発表者の入力に進む" />
</form>
<form action="./correction-contribute.rb" method="post" style="display: inline">
  #{form_text}
  <input type="submit" name="kakunin" value="修正する" />
</form>
EOM

else

  cat = {"oral" => "", "poster" => ""}
  if cgi["cat"] == "口頭"
    cat["oral"] = "checked"
  elsif cgi["cat"] == "ポスター"
    cat["poster"] = "checked"
  end
  
  coauthor = Array.new(10)
  coauthor[cgi["co-author"].to_i] = "selected"
  
  if cgi["award"] == "申込む"
    award = "checked"
  else
    award = ""
  end

print <<EOM
    <h1>発表申込フォーム</h1>

      <p><span style="color: red">入力内容に誤りがあります!</span> <br />
        ご記入いただいた内容を再確認してください。<br />
        <span style="color: red">#{message}</span></p>

    <hr />
    

  <form action="./confirm-contribute.rb" method="post">

     <h2>お名前 Name</h2>
      <table>
	<tr><th>姓</th><th>名</th></tr>
	<tr>
	  <td><input type="text" name="lname" value="#{cgi["lname"]}" size="20"/></td>
	  <td><input type="text" name="fname" value="#{cgi["fname"]}"  size="20" /></td>
	</tr>
	<tr>
	  <td class="ex">ex) 西郷; Mozart</td><td class="ex">ex) 隆盛; Wolfgang A.</td>
	</tr>
      </table>
      
      <h2>ご所属 Affiliation</h2>
      <table>
	<tr><td><input type="text" name="affil" value="#{cgi["affil"]}" size="90" /></td></tr>
	<tr><td class="ex">例) 鹿児島大・理; 京都大・霊長研 Faculty of Sciences, Kagoshima Univ.; Primate Research Institute, Kyoto Univ.</td></tr>
      </table>

      <h2>電子メール E-Mail</h2>
      <table>
	<tr><td><input type="text" name="email" value="#{cgi["email"]}" size="50" /></td></tr>
     </table>

     <h2>発表種別 Category</h2>

     <table>
     <tr><td><input type="radio" name="cat" value="口頭" #{cat["oral"]} />口頭 Oral
	  <input type="radio" name="cat" value="ポスター"  #{cat["poster"]} />ポスター Poster</td></tr>
     </table>
 
     <h2>演題 Title</h2>
     <table>
     <tr><th>和文</th></tr>
     <tr><td><input type="text" name="title" value="#{cgi["title"]}" size="100" /></td></tr>
     <tr><th>Engligh</th></tr>
     <tr><td><input type="text" name="title-en" value="#{cgi["title-en"]}" size="100" /></td></tr>
     </table>

     <h2>発表者の人数 Number of co-authors</h2>
     <table>
	<tr><td><select name="co-author">
	    <option value="0" #{coauthor[0]}>(選択してください please select)</option>
	    <option value="1"  #{coauthor[1]}>1 (単独)</option>
	    <option value="2"  #{coauthor[2]}>2</option>
	    <option value="3"  #{coauthor[3]}>3</option>
	    <option value="4"  #{coauthor[4]}>4</option>
	    <option value="5"  #{coauthor[5]}>5</option>
	    <option value="6"  #{coauthor[6]}>6</option>
	    <option value="7"  #{coauthor[7]}>7</option>
	    <option value="8"  #{coauthor[8]}>8</option>
	    <option value="9"  #{coauthor[9]}>9</option>
	    <option value="10" #{coauthor[10]}>10</option></select>人</td></tr>
     </table>

     <h2>優秀発表賞 Student Award</h2>
     <table>
	<tr><td><input type="checkbox" name="award" value="申込む" #{award} />申込む Entry</td></tr>
     </table>

    <p style="text-align: center"><input type="submit" name="kakunin" value="確認画面へ進む" /></p>
  </form>
  
EOM
end

print <<EOM
</div>
</body>
</html>
EOM
