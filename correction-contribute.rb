#!/usr/bin/ruby
# coding: utf-8
print "Content-Type: text/html\n\n"

require 'cgi'

cgi = CGI.new

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
    <h1>発表申込フォーム</h1>

    <p>発表予定の方は、下記のフォームからお申込みください。</p>

    <hr />
    

  <form action="./confirm-contribute.rb" method="post">

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

     <h2>共同発表者の人数 Number of co-authors</h2>
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
</div>
</body>
</html>

EOM