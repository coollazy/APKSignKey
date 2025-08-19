# APKBuilder

Android APK 重新封裝的套件

## Enviorment

***Mac***

- 預先安裝 [JDK](https://www.oracle.com/java/technologies/downloads/#jdk22-mac)

- 測試 JDK 是否安裝成功
	
	```
	java --version
	```

- JDK 安裝失敗，[請參考這裡](https://blog.gslin.org/archives/2022/12/28/11009/mac-%E4%B8%8A%E7%94%A8-homebrew-%E5%AE%89%E8%A3%9D-java-%E7%9A%84%E6%96%B9%E5%BC%8F/)
	

- 預先安裝 [Android studio](https://developer.android.com/studio)，並啟動 Android Studio 完成安裝 Android SDK。

- 預先安裝 [apktool](https://apktool.org/docs/install)

	```
	brew install apktool
	```

- 測試是否安裝 apktool 成功

	```
	apktool --version
	
	// Output => 2.9.3
	```

## Usage

***Swift Package Manager***
	
```swift
dependencies: [
    .package(name: "APKBuilder", url: "git@gitlab.baifu-tech.net:ios/components/apkbuilder.git", from: "1.5.0"),
],
```

## Example

- 詳細使用方式可參考 `Exmaple`

### APKBuilder

- 初始化解壓縮，build 新的 APK

	```swift
	do {
		// 初始化 builder
		let templateAPKURL: URL = URL(string: "your_original_apk_local_file_path")
		let builder = try APKBuilder(templateAPKURL)
		
		// 產生新 APK
		let toAPKURL: URL = URL(string: "the_path_of_apk_you_want")
		try builder.build(to: toAPKURL)
		
		// 簽名後才能正常安裝
		APKBuilder.signature(signKey: signKey, from: newApkURL, toDirectory: newApkURL)
	}
	catch {
	}
	```
	> 產生出來的 APK 若有修改內容，無法直接安裝到手機上
	>
	> 需要執行 APKBuilder.signature 後，才能正常安裝到手機上

- 用指令產生金鑰

	```
	keytool -genkey -v -keystore ReleaseKey.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-alias
	```

- 使用 SignKey 產生金鑰

	```swift
	do {
		let signKey = try SignKey.generateKey(name: "releaseKey", password: "123456", storePassword: "123456")
		print("signKey 的檔案位置 => \(signKey.url)")
	}
	catch {
	}
	```

- 用 SignKey 讀取金鑰
	
	```swift
	do {
		let signKey = try SignKey(url: URL(string: "ReleaseKey.jks"), name: "releaseKey", password: "123456", storePassword: "123456")
	}
	catch {
	}
	```