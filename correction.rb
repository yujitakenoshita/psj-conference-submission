#!/usr/bin/ruby
# coding: utf-8
print "Content-Type: text/html\n\n"

# CGI関連のライブラリをロード
require 'cgi'

# cgi オブジェクト：フォームの入力情報が格納される
cgi = CGI.new

# 会員種別 (status) にチェックがされていれば、該当部分をチェック
if cgi["status"] == "一般"
  full = "checked"
  student = ""
elsif cgi["status"] == "学生"
  full = ""
  full = "checked"
end

# 懇親会の参加にチェックがされているか確認
if cgi["banquet"] == "参加する"
  banquet = "checked"
else
  banquet = ""
end
  
# 共通ヘッダ部分を出力
print File.read('common-head.html')

# 参加申込フォームのヘッダ部分を出力
print File.read('registration-head.html')

# フォーム部分を出力
print <<EOM
<form action="./confirm.rb" method="post">
  <h2>お名前 Name</h2>
  <table>
    <tr><th>姓 Last name</th><th>名 First & middle name</th></tr>
    <tr>
      <td><input type="text" name="lname" value="#{cgi["lname"]}" size="20"/></td>
      <td><input type="text" name="fname" value="#{cgi["fname"]}"  size="15" /></td>
    </tr>
    <tr>
      <td class="ex">ex) 西郷; MOZART</td><td class="ex">ex) 隆盛; Wolfgang A.</td>
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
EOM

# 共通フッタ部分を出力
print File.read('common-foot.html')

