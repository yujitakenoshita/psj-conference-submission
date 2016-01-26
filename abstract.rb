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

  # confirmの場合のエラーチェック
  if cgi["call"] == 'confirm' then
    select = 'confirm'
    message = ""
    # 要旨の文字数チェック
    if cgi["abstract"].bytesize > 2550 then
      select = 'error'
      message = "要旨の文字数が多すぎます！ Your abstract is too long!"
    end
    # 発表者情報漏れのチェック
    enum = 1
    while enum <= cgi["co-author"].to_i do
      if cgi["author" + enum.to_s] == "" then
        select = 'error'
        message = message + "<br />発表者情報に未入力の箇所があります。Missing author(s) field."
        break
      elsif cgi["author-en" + enum.to_s] == "" then
        select = 'error'
        message = message + "<br />発表者情報に未入力の箇所があります。Missing author(s) field."
        break
      elsif cgi["affil" + enum.to_s] == "" then
        select = 'error'
        message = message + "<br />発表者情報に未入力の箇所があります。。Missing author(s) field."
        break
      else
        enum = enum + 1
      end
    end      
  else
    select = 'input'
  end

  # 入力・修正画面のヘッダ
  abst_head = File.read('head-abstract.html')

  # 修正画面のエラーメッセージ
  abst_error_messages = 
    "<p><span style='color: red'>入力内容に不備があります! Invalid field(s)!</span> <br />\n" +
    "ご記入いただいた内容を再確認してください。Check fields.<br />\n" +
    "<span style='color: red'>#{message}</span></p>\n"

  # 入力・修正画面のフォーム部分の部品
  # Contributionからの引き継ぎ内容
  authorinfo = <<EOM
   <input type="hidden" name="name" value="#{cgi["name"]}" />
   <input type="hidden" name="affil" value="#{cgi["affil"]}" />
   <input type="hidden" name="email" value="#{cgi["email"]}" />
   <input type="hidden" name="cat" value="#{cgi["cat"]}" />
   <input type="hidden" name="title" value="#{cgi["title"]}" />
   <input type="hidden" name="title-en" value="#{cgi["title-en"]}" />
   <input type="hidden" name="co-author" value="#{cgi["co-author"]}" />
   <input type="hidden" name="award" value="#{cgi["award"]}" />
EOM
  # 要旨のテキストエリアの部分
  abstract_tarea = <<EOM
   <h2>発表要旨 Abstract</h2>
     <p><span style="font-size: 90%">800字程度で、途中で改行せず、ひとつの段落で要旨を入力してください。
        改行しても無視されます。<br />
        Abstract should be no more  than about 350 words in a single paragraph, without line break 
        (Line breaks are ignored by the system). <br />
        イタリック体にしたい文字は&lt;i&gt;&lt/i&gt;で挟んでください。<br />
        If you want to use <i>italic</i> text, enclose the text with &lt;b&gt;&lt/b&gt;.<br />
        (example: &lt;i&gt;<i>イタリック/Italic</i>&lt/i&gt;<br />
     <p><textarea name="abstract" wrap="virtual" cols=82 rows=20>#{cgi["abstract"]}</textarea></p>
EOM
  # 発表者情報の部分
  first_author = <<EOM
    <h2>発表者 Author(s)</h2>
    <p span style="font-size: 90%">発表者の情報を以下に入力してください。<br />
    和文のお名前は、姓と名のあいだにスペースを入れずに入力してください。(例) <br />
    欧文のお名前は、名、姓の順に記してください。姓はすべて大文字にしてください。
    (例) MOZART Wolfgang A <br />
    For English name, first name first. Last name should be capitalized. (ex) Wolfgang A. MOZART</p>
    <fieldset>
      <legend>筆頭発表者 First author</legend>
      <p><span style="font-size: 60%">氏名 Name</span>
           <input type="text" name="author1" value="#{cgi["name"]}" size="25"> 
           <span style="font-size: 60%">例) 黒田清輝; Wolfgang A. MOZART</span><br />
           <span style="font-size: 60%;">Name in English</span>
           <input type="text" name="author-en1" value="#{cgi["author-en1"]}" size="40">
           <span style="font-size: 60%"> ex) Seiki KURODA; Wolfgang A. MOZART</span><br />
           <span style="font-size: 60%; color: red">Please fill both Japanese and English fields.</span>
      <p><span style="font-size: 60%">所属 Affiliation</span>
           <input type="text" name="affil1" value="#{cgi["affil"]}" size="60"></p>
     </fieldset>
EOM
  # 共同発表者の分を、人数に応じて生成する。
  co_authors = ""
  if cgi["co-author"].to_i >= 2 then
    num = 1
    vauthor = ""
    vauthen = ""
    vaffil = ""
    while num < cgi["co-author"].to_i do
      num = num + 1
      vauthor = cgi["author" + num.to_s]
      vauthen = cgi["author-en" + num.to_s]
      vaffil = cgi["affil" + num.to_s]
      co_authors = co_authors +  <<EOM
      <fieldset>
        <legend>第#{num}発表者 Author #{num}</legend>
        <p><span style="font-size: 60%;">氏名 Name</span>
           <input type="text" name="author#{num}" value="#{vauthor}" size="20"/>
           <span style="font-size: 60%">例) 中馬庚; Franz J. HAYDN</span><br />
           <span style="font-size: 60%;">Name in English</span>
           <input type="text" name="author-en#{num}" value="#{vauthen}" size="40" />
           <span style="font-size: 60%"> ex) CHUMAN Kanae; HAYDN Franz J</span><br />
           <span style="font-size: 60%; color: red">Please fill both Japanese and English fields.</span></p>
        <p><span style="font-size: 60%">所属 Affiliation</span>
           <input type="text" name="affil#{num}" value="#{vaffil}" size="60"></p>
     </fieldset>
EOM
    end
  end
  
  # 入力画面のフォーム部分 
  abst_input_form = <<EOM
  <form action="./abstract.rb" method="post">
  #{authorinfo}
  #{abstract_tarea}
  #{first_author}
  #{co_authors}
  <input type="hidden" name="call" value="confirm" />
  <p style="text-align: center"><input type="submit" name="kakunin" value="確認する" /></p>
  </form>
EOM

  # 確認画面の部品
  # 要旨テキスト
  abst_text = cgi["abstract"]
  # 著者情報
  # 筆頭著者の名前をまず挿入
  authors = cgi["author1"] + " (" + cgi["affil1"] + ")"
  authorsEn = cgi["author-en1"]
  authors_hidden = <<EOM
  <input type="hidden" name="author1" value="#{cgi["author1"]}" />
  <input type="hidden" name="affil1" value="#{cgi["affil1"]}" />
  <input type="hidden" name="author-en1" value="#{cgi["author-en1"]}" />
EOM
  # 共同発表者の人数にあわせ、共同発表者の名前を追加
  numauthors = cgi["co-author"].to_i
  if numauthors > 1 then
    num = 1
    while num < numauthors do
      num = num + 1
      if cgi["author" + num.to_s] == ""
        break
      else
        authors = authors + "，" + cgi["author" + num.to_s] + "（" + cgi["affil" + num.to_s] + "）"
        authorsEn = authorsEn + ", " + cgi["author-en" + num.to_s]
        authors_hidden = authors_hidden + <<EOM
       <input type="hidden" name="author#{num.to_s}" value="#{cgi["author" + num.to_s]}" />
       <input type="hidden" name="affil#{num.to_s}" value="#{cgi["affil" + num.to_s]}" />
       <input type="hidden" name="author-en#{num.to_s}" value="#{cgi["author-en" + num.to_s]}" />
EOM
      end
    end
  end

  abst_confirm = <<EOM
   <h1>発表申込：申込み内容の確認 Confirmation</h1>
   <p>以下の内容でよろしいでしょうか。Please confirm your entry.</p>
    <hr />

   <h2>演題 Title</h2>
     <table>
       <tr><th>Original Title</th><td>#{cgi["title"]}</td></tr>
       <tr><th>English Title</th><td>#{cgi["title-en"]}</td></tr>
     </table>
   <h2>発表者 Author(s)</h2>
     <table>
       <tr><th>発表者 Name(s)</th><td>#{authors}</td></tr>
       <tr><th>English Name(s)</th><td>#{authorsEn}</td></tr>
     </table>
   <h2>要旨 Abstract</h2>
     <p>　#{abst_text}</p>
   <h2>発表種別 Category</h2>
     <p>#{cgi["cat"]}</p>
   <h2>発表賞 Presentation Award</h2>
     <p>#{cgi["award"]}</p>
EOM

  # 確認画面の hidden フォーム
  abst_hidden_form = <<EOM
  #{authorinfo}
   <input type="hidden" name="authors" value="#{authors}" />
   <input type="hidden" name="authorsEn" value="#{authorsEn}" />
   <input type="hidden" name="abstract" value="#{abst_text}" />
  #{authors_hidden}
EOM


  # 確認画面のボタン：送信か修正か
  abst_button = <<EOM
   <form action="./send-abstract.rb" method="post" style="display: inline">
      #{abst_hidden_form}
      <input type="submit" name="kakunin" value="この内容で送信する Submit" />
   </form>
   <form action="./abstract.rb" method="post" style="display: inline">
      #{abst_hidden_form}
      <input type="submit" name="kakunin" value="修正する Modify field(s)" />
   </form>
EOM
  
  ###################################
  ###   プログラム本体            ###
  ###################################
  
  # 共通ヘッダ部分を出力
  print File.read('head-common.html')
  
  # selectの値によって、初期入力画面/エラー画面/確認画面を出力
  case select
  when 'input' then
    print abst_head
    print abst_input_form
  when 'error' then
    print abst_head
    print abst_error_messages
    print abst_input_form
  when 'confirm' then
    print abst_confirm
    print abst_button
  else
    print "<p>原因不明のエラーが発生しました。 Select: #{select}<br />\n" +
          'おそれいりますが、もう一度最初の画面からやりなおしてください。</p>' +
          '<p>We are sorry, an error occured during process. <br />' +
          'Please return to registration page.</p>'
  end
  
  # 共通フッタ部分を出力
  print File.read('foot-common.html')

 
rescue
  error_cgi
end
