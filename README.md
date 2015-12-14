# psj-conference-submission

## Overview

	- 日本霊長類学会の年次大会用のWeb参加・発表申込フォームとCGIスクリプト
	- フォームからの入力情報をローカルで処理してデータベースを構築し、要旨集を自動生
	  成するスクリプト
	- 将来的には、汎用性を高め、多くの学会で利用可能なものにしたい

## Requirements

	- ウェブサーバー
      - Apache2
	  - sendmail
	  - Ruby 2.0 or later
	- ローカル
	  - Python 
	  - TeX-Live ?
	  - pandoc ?

	
## Lisences

PSJ Conference Submission Forms & Scripts
Copyright (C) 2015 Yuji TAKENOSHITA, Hiroki KODA

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
