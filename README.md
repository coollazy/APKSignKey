# APKSignKey

![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![SPM](https://img.shields.io/badge/SPM-Supported-green)
[![CI](https://github.com/coollazy/APKSignKey/actions/workflows/ci.yml/badge.svg)](https://github.com/coollazy/APKSignKey/actions/workflows/ci.yml)

產生 Android APK Sign Key

## Enviorment

***Mac***

- 安裝 [JDK](https://www.oracle.com/java/technologies/downloads/#jdk22-mac)

	```bash
	# 安裝 OpenJDK (推薦)
	brew install openjdk
	
	# 或安裝 JRE (較小的安裝包)
	brew install openjdk --jre
	```

- 測試 JDK 是否安裝成功
    
    ```bash
    java --version
    ```
    > java 22.0.1 2024-04-16
    >
    > Java(TM) SE Runtime Environment (build 22.0.1+8-16)
    >
    > Java HotSpot(TM) 64-Bit Server VM (build 22.0.1+8-16, mixed mode, sharing)

- 測試是否安裝 apktool 成功

    ```bash
    keytool --version
    ```
    > keytool 22.0.1

- JDK 安裝失敗，[請參考這裡](https://blog.gslin.org/archives/2022/12/28/11009/mac-%E4%B8%8A%E7%94%A8-homebrew-%E5%AE%89%E8%A3%9D-java-%E7%9A%84%E6%96%B9%E5%BC%8F/)

***Linux***

- 安裝 JDK

	```bash
	# Ubuntu/Debian - 只安裝 JRE (較小)
	sudo apt install default-jre
	
	# 或安裝完整 JDK
	sudo apt install default-jdk
	
	# CentOS/RHEL
	sudo dnf install java-11-openjdk
	```

***Docker***

- 待補上

## Usage

***Swift Package Manager***

- Package.swift 的 dependencies 內添加
	
	```swift
	.package(name: "APKSignKey", url: "https://github.com/coollazy/APKSignKey.git", from: "1.0.0"),
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
