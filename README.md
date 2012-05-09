sig
===

Simple Image Generator(sig).

ダミー画像を生成する簡単なRubyアプリケーションです。

インストール
-------------
```bash
git clone https://github.com/jirokun/sig.git
cd sig
bundle install
```

使い方
------
下記コマンドでWebサーバを起動します。
```bash
ruby sig.rb
```

ブラウザを開いて以下のURLにアクセス。
- http://localhost:4567/300x200
- http://localhost:4567/300x400?color=f00
- http://localhost:4567/500x300?background-color=f0f
- http://localhost:4567/300x200?background-color=f0f&color=f00
- http://localhost:4567/200x200?font=osaka&background-color=f0f&color=f00
- http://localhost:4567/200x200?font=osaka&text=%E6%97%A5%E6%9C%AC%E8%AA%9E

ライセンス
----------
New BSD License
