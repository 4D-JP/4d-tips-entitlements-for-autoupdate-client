# 4d-tips-entitlements-for-autoupdate-client
クライアント自動アップデートのコード署名をカスタマイズするには

## 概要

デザインモードの[アプリケーションビルド](https://developer.4d.com/docs/ja/19/Desktop/building/#アプリケーションのビルド)は，アプリのコード署名をサポートしています。署名には，*4D.app* アプリケーションの*Resources* フォルダーの中にあるシェルスクリプト[*SignApp.sh*](https://github.com/4D-JP/4d-tips-entitlements-for-autoupdate-client/blob/main/SignApp.sh) が使用されます。

特定のリソースに対するアクセスを求めるための`--entitlements`は，同じく*4D.app* アプリケーションの*Resources* フォルダーの中にある[*4D.entitlements*](https://github.com/4D-JP/4d-tips-entitlements-for-autoupdate-client/blob/main/4D.entitlements) ファイルが渡されます。

`true`に設定されているのは，下記のエンタイトルメントです。

```
com.apple.security.automation.apple-events
com.apple.security.cs.allow-dyld-environment-variables
com.apple.security.cs.allow-jit
com.apple.security.cs.allow-unsigned-executable-memory
com.apple.security.cs.debugger
com.apple.security.cs.disable-executable-page-protection
com.apple.security.cs.disable-library-validation
com.apple.security.device.audio-input
com.apple.security.device.camera
com.apple.security.personal-information.addressbook
com.apple.security.personal-information.calendars
com.apple.security.personal-information.location
com.apple.security.personal-information.photos-library
```

コード署名は，デスクトップ・サーバー・クライアントのそれぞれに付与されます。

自動アップデート用のクライアントは，コード署名され，圧縮されてサーバーの*Upgrade4DClient* フォルダーに組み込まれます（*update.mac.4darchive*）。その後，サーバーが署名されます。

**注記**: *4darchive* は4Dのクライアント/サーバーが使用する独自の圧縮形式ですが，v19 R2以降，標準的な*zip* 形式を選択することもできるようになりました。

* [UseStandardZipFormat](https://doc.4d.com/4Dv19R7/4D/19-R7/UseStandardZipFormat.300-5943918.ja.html)

## 問題

通常のビルドであれば，署名をカスタマイズしたり，上書きする機会があります。

* ビルド
* ビルド〜署名

しかし，自動アップデートのクライアントは一気にアーカイブまで進むため，ビルドアプリの署名をカスタマイズする機会がありません。

* ビルド〜署名〜アーカイブ

## 不完全な回避策

* *4D.app* アプリケーションの*Resources* フォルダーの中にある[*4D.entitlements*](https://github.com/4D-JP/4d-tips-entitlements-for-autoupdate-client/blob/main/4D.entitlements) ファイルを書き換える

アプリケーションの中にあるファイルを書き換えると，コード署名が無効になります。また，アップデートがある度に同じことを繰り返さなければなりません。

* 4D Volume Desktopを署名する

署名はビルド前ではなく，ビルド後でなければならないため，この方法は効果がありません。

* 自動アップデート用のクライアントを単独でビルド〜署名し，*zip*形式でアーカイブする

[ClientMacFolderToWin](https://doc.4d.com/4Dv19R7/4D/19-R7/ClientMacFolderToWin.300-5943942.ja.html)とは違い，[ClientMacFolderToMac](https://doc.4d.com/4Dv19R7/4D/19-R7/ClientMacFolderToMac.300-5943953.ja.html)には*4darchive* 形式のクライアントを渡すことができません。

## 回避策

下記の要領で自動アップデート用のクライアントを署名することができます。

1. *4D Volume Desktop* を作業フォルダーにコピーします。マスターを書き換えないで済ませるためです。

1. 必要なエンタイトルメントで*4D Volume Desktop* を署名します。アプリケーションビルドのコード署名は，すでに署名されているモジュールの署名を上書きするオプション（`--force --deep`）になっていないことを利用します。*Info.plist* をカスタマイズすることもできますが，`CFBundleVersion`は*4D Volume Desktop* のバージョンチェックに使用されているため，変更するとビルドが中止されてしまうので注意が必要です。

1. コピーした*4D Volume Desktop* のパスを指定してクライアント/サーバー版アプリケーションをビルドします。自動アップデート用のクライアントはすでに署名されているため，カスタマイズされたエンタイトルメントが上書きされずに残されます。

1. 公証をパスするためには，*framework* *bundle* *plugin* *app* *dylib* *kext* といったバンドルに加えて，UNIX実行ファイル，*html* *js* *json* *so* といったファイルもコード署名する必要があります。これには，ビルド版サーバーアプリケーションの中にある*Upgrade4DClient* フォルダーの*info.json* も含まれます。署名する代わりに，実行権限を取り除くこともできます。

```
chmod 666
```

