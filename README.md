# 4d-tips-entitlements-for-autoupdate-client
クライアント自動アップデートのコード署名をカスタマイズするには

デザインモードの[アプリケーションビルド](https://developer.4d.com/docs/ja/19/Desktop/building/#アプリケーションのビルド)は，アプリのコード署名をサポートしています。署名には，*4D.app* アプリケーションの*Resources* フォルダーの中にあるシェルスクリプト[*SignApp.sh*](https://github.com/4D-JP/4d-tips-entitlements-for-autoupdate-client/blob/main/SignApp.sh) が使用されます。

特定のリソースに対するアクセスを求めるための`--entitlements`は，同じく*4D.app* アプリケーションの*Resources* フォルダーの中にある[*4D.entitlements*](https://github.com/4D-JP/4d-tips-entitlements-for-autoupdate-client/blob/main/4D.entitlements) ファイルが渡されます。

`true`に設定されているのは，下記のエンタイトルメントです。

* `com.apple.security.automation.apple-events`
* `com.apple.security.cs.allow-dyld-environment-variables`
* `com.apple.security.cs.allow-jit`
* `com.apple.security.cs.allow-unsigned-executable-memory`
* `com.apple.security.cs.debugger`
* `com.apple.security.cs.disable-executable-page-protection`
* `com.apple.security.cs.disable-library-validation`
* `com.apple.security.device.audio-input`
* `com.apple.security.device.camera`
* `com.apple.security.personal-information.addressbook`
* `com.apple.security.personal-information.calendars`
* `com.apple.security.personal-information.location`
* `com.apple.security.personal-information.photos-library`
