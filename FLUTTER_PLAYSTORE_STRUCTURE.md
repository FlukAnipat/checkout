# 📱 FLUTTER PROJECT STRUCTURE FOR PLAY STORE
# ===========================================

## 🎯 **CORRECT FLUTTER PROJECT STRUCTURE:**

```
shwe_flash_flutter/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── config/
│   │   ├── api_config.dart
│   │   ├── app_config.dart
│   │   └── theme_config.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── utils/
│   │   └── extensions/
│   ├── data/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── services/
│   │       ├── api_service.dart
│   │       ├── auth_service.dart
│   │       └── storage_service.dart
│   ├── domain/
│   │   ├── entities/
│   │   ├── usecases/
│   │   └── repositories/
│   ├── presentation/
│   │   ├── providers/
│   │   │   ├── auth_provider.dart
│   │   │   ├── vocabulary_provider.dart
│   │   │   └── payment_provider.dart
│   │   ├── screens/
│   │   │   ├── auth/
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── register_screen.dart
│   │   │   ├── home/
│   │   │   │   └── home_screen.dart
│   │   │   ├── vocabulary/
│   │   │   │   ├── hsk_levels_screen.dart
│   │   │   │   └── vocabulary_detail_screen.dart
│   │   │   └── payment/
│   │   │       └── payment_screen.dart
│   │   ├── widgets/
│   │   │   ├── common/
│   │   │   └── custom/
│   │   └── themes/
│   └── l10n/
│       ├── app_en.arb
│       ├── app_th.arb
│       └── app_zh.arb
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
├── test/
├── integration_test/
├── android/
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   ├── kotlin/
│   │   │   └── res/
│   │   └── build.gradle
│   ├── build.gradle
│   └── gradle.properties
├── ios/
│   ├── Runner/
│   └── Podfile
├── pubspec.yaml
├── README.md
└── .gitignore
```

---

## 🚀 **PLAY STORE READY FILES:**

### **1. android/app/build.gradle**
```gradle
android {
    namespace 'com.shweflash.app'
    compileSdk 34

    defaultConfig {
        applicationId "com.shweflash.app"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0.0"

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            // Enable Proguard
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            
            // Signing config for Play Store
            signingConfig signingConfigs.release
        }
        debug {
            signingConfig signingConfigs.debug
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }
}

dependencies {
    implementation 'androidx.core:core-ktx:1.12.0'
    implementation 'androidx.lifecycle:lifecycle-runtime-ktx:2.7.0'
    implementation 'androidx.activity:activity-compose:1.8.2'
}
```

### **2. android/app/src/main/AndroidManifest.xml**
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <application
        android:label="Shwe Flash"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:theme="@style/LaunchTheme">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:windowSoftInputMode="adjustResize">
            
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
```

### **3. pubspec.yaml (Play Store Ready)**
```yaml
name: shwe_flash
description: HSK Chinese learning app for Myanmar students
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter
  
  # UI & State Management
  cupertino_icons: ^1.0.6
  provider: ^6.0.5
  
  # Networking
  http: ^1.1.0
  dio: ^5.3.2
  
  # Storage
  flutter_secure_storage: ^8.0.0
  shared_preferences: ^2.2.2
  
  # Utilities
  intl: ^0.18.1
  uuid: ^4.2.1
  json_annotation: ^4.8.1
  
  # Localization
  flutter_localizations:
    sdk: flutter
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.7
  json_serializable: ^6.7.1

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
    
  fonts:
    - family: CustomFont
      fonts:
        - asset: assets/fonts/CustomFont-Regular.ttf
        - asset: assets/fonts/CustomFont-Bold.ttf
          weight: 700

flutter_intl:
  enabled: true
  class_name: S
  main_locale: en
  arb_dir: lib/l10n
  output_dir: lib/generated
```

---

## 🎯 **CORRECTED FILES FOR PLAY STORE:**

### **lib/config/api_config.dart**
```dart
class ApiConfig {
  // 🚀 Production API (Change to your actual Vercel domain)
  static const String baseUrl = 'https://shwe-flash.vercel.app/api';
  
  // 🔐 App API Key
  static const String appApiKey = 'shwe_flash_app_key_production_2024';
  
  // 🎯 Environment
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static const bool useMockData = false;
  
  static String get currentBaseUrl {
    if (useMockData) return 'http://localhost:3000/mock';
    return isProduction ? baseUrl : 'http://localhost:5001/api';
  }
}
```

### **lib/data/services/api_service.dart**
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';

class ApiService {
  static Future<Map<String, dynamic>> loginFlutter(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.currentBaseUrl}/auth/flutter/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'appApiKey': ApiConfig.appApiKey,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) return data;
        throw Exception(data['error'] ?? 'Login failed');
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
```

### **lib/presentation/providers/auth_provider.dart**
```dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = FlutterSecureStorage();
  String? _token;
  Map<String, dynamic>? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;
  String? get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await ApiService.loginFlutter(email, password);
      
      if (response['success']) {
        _token = response['token'];
        _user = response['user'];
        
        await _storage.write(key: 'shwe_flash_token', value: _token);
        await _storage.write(key: 'shwe_flash_user', value: jsonEncode(_user));
        
        notifyListeners();
      } else {
        _setError(response['error'] ?? 'Login failed');
      }
    } catch (e) {
      _setError('Login failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
```

---

## 🚀 **PLAY STORE DEPLOYMENT STEPS:**

### **1. Build Release APK**
```bash
flutter build apk --release
```

### **2. Build Release AAB (Recommended)**
```bash
flutter build appbundle --release
```

### **3. Upload to Play Console**
- Go to Play Console
- Create new app
- Upload AAB file
- Fill store listing
- Set pricing
- Submit for review

---

## 🎯 **IMPORTANT FOR PLAY STORE:**

1. **Application ID:** `com.shweflash.app`
2. **Version Code:** Start from 1
3. **Signing Keys:** Generate release keys
4. **Privacy Policy:** Required for Play Store
5. **Target SDK:** 34 (latest)
6. **Min SDK:** 21 (Android 5.0+)

**🎉 โครงสร้างนี้พร้อมสำหรับ Play Store deployment!**
