Class constructor()
	
/*
	
アプリの名称
	
*/
	
	$name:="TEST"
	
	This:C1470.applicationName:=$name
	
/*
	
Info.plistに表示するバージョン番号
	
*/
	
	This:C1470.versionString:="1.0.0"
	
/*
	
クライアント自動アップデート用の判定に使用するバージョン番号
	
*/
	
	This:C1470.CurrentVers:=1
	
/*
	
.icnsファイルのパス
iconutil等を使用してアイコンセットを用意する
	
*/
	
	This:C1470.RuntimeVLIconMacPath:=Folder:C1567(fk resources folder:K87:11).folder("Images").folder("library").file("4D.icns").platformPath
	This:C1470.ServerIconMacPath:=Folder:C1567(fk resources folder:K87:11).folder("Images").folder("library").file("4D.icns").platformPath
	This:C1470.ClientMacIconForMacPath:=Folder:C1567(fk resources folder:K87:11).folder("Images").folder("library").file("4D.icns").platformPath
	
/*
	
アプリ識別子
サーバーの識別子はアプリグループを構成する接頭辞
	
*/
	
	This:C1470.serverAppIdentifier:="com.miyako.keisuke"
	This:C1470.clientAppIdentifier:="com.miyako.keisuke.client"
	This:C1470.desktopAppIdentifier:="com.miyako.keisuke.desktop"
	
/*
	
Apple Developer Program
アカウント
	
*/
	
	This:C1470.username:="keisuke.miyako@4d.com"
	This:C1470.signingIdentity:="Developer ID Application: keisuke miyako (Y69CWUC25B)"
	
/*
	
True: altoolで署名
False: notarytoolで署名
	
*/
	
	$useOldTool:=False:C215
	
/*
	
キーチェーンに登録されたプロフィール
altoolを使用する場合
$credentials.password:="@keychain:altool"  
アプリ用パスワードをリテラルに渡す場合
$credentials.password:="password"  
	
*/
	
	This:C1470.keychainProfile:="notarytool"
	This:C1470.applicationsFolder:=Folder:C1567(fk applications folder:K87:20)
	This:C1470.resourcesFolder:=Folder:C1567(Get 4D folder:C485(Current resources folder:K5:16); fk platform path:K87:2)
	
/*
	
追加で設定するエンタイトルメント
	
*/
	
	This:C1470.entitlements:=New object:C1471
	
	This:C1470.entitlements["com.apple.security.app-sandbox"]:=False:C215
	This:C1470.entitlements["com.apple.security.application-groups"]:=New collection:C1472(This:C1470.serverAppIdentifier)
	This:C1470.entitlements["com.apple.security.network.client"]:=True:C214
	This:C1470.entitlements["com.apple.security.network.server"]:=True:C214
	This:C1470.entitlements["com.apple.security.files.user-selected.read-write"]:=True:C214
	This:C1470.entitlements["com.apple.security.files.user-selected.executable"]:=True:C214
	
/*
	
その他のオプション
	
*/
	
	This:C1470.removeCEF:=True:C214
	This:C1470.removePHP:=True:C214
	
	This:C1470.version:=Application version:C493($build)
	If (Substring:C12(This:C1470.version; 3; 1)="0")
		This:C1470.folderName:="4D v"+Substring:C12(This:C1470.version; 1; 2)+"."+Substring:C12(This:C1470.version; 4; 1)
	Else 
		This:C1470.folderName:="4D v"+Substring:C12(This:C1470.version; 1; 2)+" R"+Substring:C12(This:C1470.version; 3; 1)
	End if 
	
	This:C1470.releaseFolder:=Folder:C1567(Get 4D folder:C485(Database folder:K5:14); fk platform path:K87:2).parent.folder("Releases")
	This:C1470.releaseFolder.create()
	
/*
	
スタートアップアプリ（デスクトップモードでクライアントを起動する場合）
	
*/
	
	This:C1470.startupFolder:=Folder:C1567(Get 4D folder:C485(Database folder:K5:14); fk platform path:K87:2).parent.folder("Compiled Database").folder("startup")
	
/*
	
アーカイブ形式
dmg pkg zip
	
*/
	
	This:C1470.format:=".dmg"
	
Function _getCredentials()->$credentials : Object
	
	$credentials:=New object:C1471
	$credentials.username:=This:C1470.username
	$credentials.password:=This:C1470.password
	$credentials.keychainProfile:=This:C1470.keychainProfile
	$credentials.signingIdentity:=This:C1470.signingIdentity
	
Function _escape_param($escape_param : Text)->$param : Text
	
	$param:=$escape_param
	
	$metacharacters:="\\!\"#$%&'()=~|<>?;*`[] "
	C_LONGINT:C283($i)
	For ($i; 1; Length:C16($metacharacters))
		$metacharacter:=Substring:C12($metacharacters; $i; 1)
		$param:=Replace string:C233($param; $metacharacter; "\\"+$metacharacter; *)
	End for 
	
Function _makeUpdaterDaemon($app : 4D:C1709.Folder)
	
	$plist:=$app.folder("Contents").folder("Resources").folder("Updater").folder("Updater.app").folder("Contents").file("Info.plist")
	
	If ($plist.exists)
		
		$dom:=DOM Parse XML source:C719($plist.platformPath)
		
		If (OK=1)
			
			$key:=DOM Find XML element:C864($dom; "/plist/dict/key[text()='LSUIElement']")
			
			If (OK=1)
				$value:=DOM Get next sibling XML element:C724($key)
				If (OK=1)
					DOM REMOVE XML ELEMENT:C869($value)
				End if 
				DOM REMOVE XML ELEMENT:C869($key)
			End if 
			
			$key:=DOM Create XML element:C865($dom; "/plist/dict/key")
			DOM SET XML ELEMENT VALUE:C868($key; "LSUIElement")
			$value:=DOM Create XML element:C865($dom; "/plist/dict/true")
			
			$key:=DOM Find XML element:C864($dom; "/plist/dict/key[text()='LSBackgroundOnly']")
			
			If (OK=1)
				$value:=DOM Get next sibling XML element:C724($key)
				If (OK=1)
					DOM REMOVE XML ELEMENT:C869($value)
				End if 
				DOM REMOVE XML ELEMENT:C869($key)
			End if 
			
			$key:=DOM Create XML element:C865($dom; "/plist/dict/key")
			DOM SET XML ELEMENT VALUE:C868($key; "LSBackgroundOnly")
			$value:=DOM Create XML element:C865($dom; "/plist/dict/true")
			
			DOM EXPORT TO FILE:C862($dom; $plist.platformPath)
			
			If (OK=1)
				
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $plist.parent.platformPath)
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "true")
				
				$command:="plutil -convert xml1 "+This:C1470._escape_param($plist.fullName)
				
				var $stdIn; $stdOut; $stdErr : Blob
				
				LAUNCH EXTERNAL PROCESS:C811($command; $stdIn; $stdOut; $stdErr; $pid)
				
			End if 
			
			DOM CLOSE XML:C722($dom)
			
		End if 
		
	End if 
	
Function _signApp($buildApp : Object; $identifier : Text; $folderName : Text; $appName : Text; $useOldTool : Boolean)->$status : Object
	
	$app:=$buildApp.getPlatformDestinationFolder().folder($folderName).folder($appName+".app")
	
	This:C1470._makeUpdaterDaemon($app)
	
	$status:=New object:C1471("app"; $app)
	
	$plist:=New object:C1471("CFBundleShortVersionString"; This:C1470.versionString; "CFBundleIdentifier"; $identifier)
	
	$credentials:=This:C1470._getCredentials()
	
	$signApp:=cs:C1710.SignApp.new($credentials; $plist)
	
	If (This:C1470.entitlements#Null:C1517)
		$signApp.entitlements:=This:C1470.entitlements
	End if 
	
	If (This:C1470.removeCEF#Null:C1517)
		$signApp.options.removeCEF:=This:C1470.removeCEF
	End if 
	
	If (This:C1470.removePHP#Null:C1517)
		$signApp.options.removePHP:=This:C1470.removePHP
	End if 
	
	$status.sign:=$signApp.sign($app)
	
	$status.archive:=$signApp.archive($app; This:C1470.format)
	
	If ($status.archive.success)
		
		$status.notarize:=$signApp.notarize($status.archive.file; $useOldTool)
		
		If ($status.notarize.success)
			
			$app:=$signApp.destination.folder($signApp.versionID).file($appName+This:C1470.format)
			
/*
			
必要に応じてファイルサーバーなどにアップロードする
			
*/
			
		End if 
		
	End if 
	
Function buildAutoUpdateClientServer()->$status : Object
	
	This:C1470.clean()
	
	$version:=This:C1470.version
	This:C1470.folderName:=This:C1470.folderName
	
	$alteredVolumeDesktop:=This:C1470._prepareClientRuntime(New collection:C1472("UDP"; "Window Control for Mac"))
	
	$buildApp:=cs:C1710.BuildApp.new(New object:C1471)
	
	$buildApp.findLicenses(New collection:C1472("4DOE"; "4UOE"; "4UOS"; "4DOM"; "4DDP"))
	$isOEM:=($buildApp.settings.Licenses.ArrayLicenseMac.Item.indexOf("@4DOE@")#-1)
	
/*
	
不要なコンポーネントを除外する
	
*/
	
	$buildApp.settings.ArrayExcludedComponentName.Item:=New collection:C1472("4D Mobile App Server")  //; "4D ViewPro"; "4D WritePro Interface"; "4D Progress"; "4D SVG")
	$buildApp.settings.BuildApplicationName:=This:C1470.applicationName
	$buildApp.settings.BuildMacDestFolder:=This:C1470.releaseFolder.folder(This:C1470.versionString).platformPath
	$buildApp.settings.SourcesFiles.CS.ServerIncludeIt:=True:C214
	$buildApp.settings.SourcesFiles.CS.ClientMacIncludeIt:=True:C214
	$buildApp.settings.SourcesFiles.CS.ServerMacFolder:=This:C1470.applicationsFolder.folder(This:C1470.folderName).folder("4D Server.app").platformPath
	$buildApp.settings.SourcesFiles.CS.ClientMacFolderToMac:=$alteredVolumeDesktop.platformPath
	$buildApp.settings.SourcesFiles.CS.ServerIconMacPath:=This:C1470.ServerIconMacPath
	$buildApp.settings.SourcesFiles.CS.ClientMacIconForMacPath:=This:C1470.ClientMacIconForMacPath
	$buildApp.settings.SourcesFiles.CS.IsOEM:=$isOEM
	$buildApp.settings.CS.BuildServerApplication:=True:C214
	$buildApp.settings.CS.BuildCSUpgradeable:=True:C214
	$buildApp.settings.CS.CurrentVers:=This:C1470.CurrentVers
	$buildApp.settings.CS.RangeVersMin:=This:C1470.CurrentVers
	$buildApp.settings.CS.RangeVersMax:=9
	$buildApp.settings.CS.LastDataPathLookup:="ByAppName"
	$buildApp.settings.SignApplication.MacSignature:=True:C214
	$buildApp.settings.SignApplication.MacCertificate:=This:C1470.signingIdentity
	$buildApp.settings.SignApplication.AdHocSign:=False:C215
	
	$buildApp.settings.Versioning.Client.ClientVersion:=This:C1470.versionString
	$buildApp.settings.Versioning.Common.CommonVersion:=This:C1470.versionString
	$buildApp.settings.Versioning.RuntimeVL.RuntimeVLVersion:=This:C1470.versionString
	$buildApp.settings.Versioning.Server.ServerVersion:=This:C1470.versionString
	
	If (Test path name:C476(This:C1470.startupFolder.platformPath)=Is a folder:K24:2)
		$buildApp.settings.SourcesFiles.CS.DatabaseToEmbedInClientMacFolder:=This:C1470.startupFolder.platformPath
	End if 
	
	$status:=$buildApp.build()
	
	If ($status.success)
		
		$logsFolder:=Folder:C1567(fk logs folder:K87:17)
		$name:=$buildApp.lastSettingsFile.name
		$file:=$logsFolder.file($name+".log.xml")
		$dom:=DOM Parse XML source:C719($file.platformPath)
		$error:=DOM Find XML element:C864($dom; "/BuildApplicationLog/Log[CodeDesc = \"NO_LICENSE_OEMMAKER\"]")
		If (OK=1)
			TRACE:C157
		End if 
		DOM CLOSE XML:C722($dom)
		
		$app:=$buildApp.getPlatformDestinationFolder().folder("Client Server executable").folder($buildApp.settings.BuildApplicationName+" Server.app")
		$file:=$app.folder("Contents").folder("Upgrade4DClient").file("info.json")
		
		If ($file.exists)
			$command:="chmod 666 "+This:C1470._escape_param($file.path)
			var $stdIn; $stdOut; $stdErr : Blob
			LAUNCH EXTERNAL PROCESS:C811($command; $stdIn; $stdOut; $stdErr)
		End if 
		
		$status:=This:C1470._signApp($buildApp; This:C1470.serverAppIdentifier; "Client Server executable"; $buildApp.settings.BuildApplicationName+" Server"; $useOldTool)
		$status:=This:C1470._signApp($buildApp; This:C1470.clientAppIdentifier; "Client Server executable"; $buildApp.settings.BuildApplicationName+" Client"; $useOldTool)
		
		$status.build:=New object:C1471("success"; True:C214)
		
	Else 
		$status.build:=New object:C1471("success"; False:C215)
	End if 
	
Function _prepareClientRuntime($pluginNames : Collection)->$alteredVolumeDesktop : 4D:C1709.Folder
	
/*
	
追加のentitlementsがあるのでさきに署名する
ただし4D Volume Desktopのバージョンは書き換えない
書き換えるとビルドがブロックされてしまう
	
*/
	
	This:C1470.folderName:=This:C1470.folderName
	
	$app:=This:C1470.applicationsFolder.folder(This:C1470.folderName).folder("4D Volume Desktop.app")
	
	$folder:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Generate UUID:C1066)
	
	$folder.create()
	
	$alteredVolumeDesktop:=$app.copyTo($folder)
	
	If ($pluginNames#Null:C1517)
		var $srcFolder; $dstFolder; $plugin : 4D:C1709.Folder
		$dstFolder:=$alteredVolumeDesktop.folder("Contents").folder("Plugins")
		$dstFolder.create()
		$srcFolder:=Folder:C1567(Get 4D folder:C485(Database folder:K5:14); fk platform path:K87:2).folder("Plugins")
		var $pluginName : Text
		For each ($pluginName; $pluginNames)
			$plugin:=$srcFolder.folder($pluginName+".bundle")
			If ($plugin.exists)
				$plugin.copyTo($dstFolder)
			End if 
		End for each 
	End if 
	
	$identifier:=This:C1470.clientAppIdentifier
	
	$plist:=New object:C1471("CFBundleIdentifier"; $identifier)
	
	$credentials:=This:C1470._getCredentials()
	
	$status:=New object:C1471("app"; $alteredVolumeDesktop)
	
	$signApp:=cs:C1710.SignApp.new($credentials; $plist)
	
	$status.sign:=$signApp.sign($alteredVolumeDesktop)
	
Function clean()
	
/*
	
全メソッドを強制的にコンパイルさせるように仕向ける
	
*/
	
	$UserPreferencesFolder:=Folder:C1567(fk database folder:K87:14).folder("userPreferences."+Current system user:C484)
	$UserPreferencesFolder.folder("CompilerIntermediateFiles").delete(Delete with contents:K24:24)
	$UserPreferencesFolder.file("methodPreferences.json").delete()
	
	$DerivedDataFolder:=Folder:C1567(fk database folder:K87:14).folder("Project").folder("DerivedData")
	$DerivedDataFolder.delete(Delete with contents:K24:24)