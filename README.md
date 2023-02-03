# 4d-tips-entitlements-for-autoupdate-client
クライアント自動アップデートのコード署名をカスタマイズするには

デザインモードの[アプリケーションビルド](https://developer.4d.com/docs/ja/19/Desktop/building/#アプリケーションのビルド)は，アプリのコード署名をサポートしています。署名には，*4D.app* アプリケーションの*Resources* フォルダーの中にあるシェルスクリプト[*SignApp.sh*](https://github.com/4D-JP/4d-tips-entitlements-for-autoupdate-client/blob/main/SignApp.sh) が使用されます。

特定のリソースに対するアクセスを求めるための`--entitlements`は，同じく4D.app* アプリケーションの*Resources* フォルダーの中にある[*4D.entitlements*](https://github.com/4D-JP/4d-tips-entitlements-for-autoupdate-client/blob/main/4D.entitlements) ファイルが渡されます。
