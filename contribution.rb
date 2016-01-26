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

  require 'cgi'
  cgi = CGI.new

  # 入力・修正画面の「確認」ボタンから呼びだされた場合
  # select に confirm をセットしたのち、
  # 入力ミスを確認し、エラーがあれば select を error に変更
  # それ以外の場合、すなわち、最初の入力が「修正」ボタンから呼びだされた場合
  # select に input をセット
  # select が confirm か input か error かによって挙動を変える
  if cgi["call"] == 'confirm' then
    select = 'confirm'
    message = ""
    if cgi["lname"] == ""
      select = 'error'
      message = message + "姓が未入力です。Missing Last name.<br />"
    end
    if cgi["fname"] == ""
      select = 'error'
      message = message + "名が未入力です。 Missing First name.<br />"
    end
    if cgi["affil"] == ""
      select = 'error'
      message = message + "所属が未入力です。 Missing affiliation.<br />"
    end
    if cgi["email"] == ""
      select = 'error'
      message = message + "E-Mailが未入力です。Missing E-Mail.<br />"
    end
    if cgi["cat"] == ""
      select = 'error'
      message = message + "発表形式を選択してください。Please select category.<br />"
    end
    if cgi["title"] == ""
      select = 'error'
      message = message + "演題が未入力です。Missing title.<br />"
    end
    if cgi["title-en"] == ""
      select = 'error'
      message = message + "英文演題が未入力です。Missing English title.<br />"
    end
    if cgi["co-author"] == "0"
      select = 'error'
      message = message + "発表者数を選択してください。Please select number of author(s).<br />"
    end
  else
    select = 'input'
  end
  
  # 発表種別を確認
  cat = {"oral" => "", "poster" => ""}
  if cgi["cat"] == "口頭"
    cat["oral"] = "checked"
  elsif cgi["cat"] == "ポスター"
    cat["poster"] = "checked"
  end
  
  # 発表者数の値を確認
  coauthor = Array.new(10)
  coauthor[cgi["co-author"].to_i] = "selected"
  
  # 発表賞申込を確認
  if cgi["award"] == "申込む"
    award = "checked"
  else
    award = ""
  end
  
  
  # 発表申込フォームのヘッド部分
  con_head =  File.read('head-contribution.html')
  
  # 入力・修正画面のエラーメッセージ
  con_error_messages =
    "<p><span style='color: red'>入力内容に誤りがあります!</span> <br />\n" +
    "ご記入いただいた内容を再確認してください。<br />\n" +
    "<span style='color: red'>#{message}</span></p>\n"
  
  
  # 発表申込のフォーム部分
  con_input_form =  <<EOM
      <form action="./contribution.rb" method="post">

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
     <tr><th>正式演題 Original Title</th></tr>
     <tr><td><input type="text" name="title" value="#{cgi["title"]}" size="100" /></td></tr>
     <tr><th>英文演題 Title in English </th></tr>
     <tr><td><input type="text" name="title-en" value="#{cgi["title-en"]}" size="100" /><br />
     <span style="color: red; font-size: 80%">正式演題が英文であっても入力してください。 Please fill even if the original title is in English.</span></td></tr>
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

     <h2>優秀発表賞 Presentation Award</h2>
     <table>
	<tr><td><input type="checkbox" name="award" value="申込む" #{award} />申込む Entry</td></tr>
     </table>

    <input type="hidden" name="call" value="confirm" />
    <p style="text-align: center"><input type="submit" name="kakunin" value="確認画面へ進む" /></p>
  </form>
EOM

  # 確認画面のhtmlソース
  con_confirm = <<EOM
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

  
  # 確認画面の hidden フォーム
  con_hidden_form = <<EOM
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
  
  # 確認画面のボタン
  con_button = <<EOM
<form action="./abstract.rb" method="post" style="display: inline">
  #{con_hidden_form}
  <input type="submit" name="kakunin" value="要旨と共同発表者の入力に進む" />
</form>
<form action="./contribution.rb" method="post" style="display: inline">
  #{con_hidden_form}
  <input type="submit" name="kakunin" value="修正する" />
</form>
EOM


  ############################
  ###   プログラム本体     ###
  ############################
  
  # 共通ヘッダ部分を出力
  print File.read('head-common.html')

  # selectの値によって、初期入力画面/エラー画面/確認画面を出力
  case select
  when 'input' then
    print con_head
    print con_input_form
  when 'error' then
    print con_head
    print con_error_messages
    print con_input_form
  when 'confirm' then
    print con_confirm
    print con_button
  else
    print "<p>原因不明のエラーが発生しました。Select: #{select}<br />\n" +
          'おそれいりますが、もう一度最初の画面からやりなおしてください。</p>' +
          '<p>We are sorry, an error occured during process. <br />' +
          'Please return to url notified in the registration confirmation mail.</p>'
  end

  # 共通フッタ部分を出力
  print File.read('foot-common.html')

rescue
  error_cgi
end
