# APKSignKey

產生 Android APK Sign Key

## Enviorment

***Mac***

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
    .package(name: "APKSignKey", url: "https://github.com/coollazy/APKSignKey.git", from: "1.0.0"),
],
```

### APKSignKey

- 載入 SignKey

	```swift
	do {
		let existedSignKey = try APKSignKey(url: signKeyURL, name: "Temp", password: "123456", storePassword: "123456")
		print("Existed sign key => \(existedSignKey.url)")
		print("Existed sign key info => \n\(try existedSignKey.getKeyInfo())")
	}
	catch {
		print(error)
	}
	```
	> 載入時會驗證密鑰庫

- 產生新的 SignKey

	```swift
	do {
		let signKey = try APKSignKey.generateKey(name: "Temp", password: "123456", storePassword: "123456")
		print("New sign key => \(signKey.url)")
		print("New sign key info => \n\(try signKey.getKeyInfo())")
	}
	catch {
		print(error)
	}
	```

- 用指令產生金鑰

	```
	keytool -genkey -v -keystore ReleaseKey.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-alias
	```