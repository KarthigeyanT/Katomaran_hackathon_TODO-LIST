plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.katomaran_hackathon"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion
    
    // Add this if you need to specify the namespace for the generated R and BuildConfig classes
    buildFeatures {
        buildConfig = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.katomaran_hackathon"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// Add this at the bottom of the file
afterEvaluate {
    android {
        defaultConfig {
            // Make sure this matches your package name
            applicationId = "com.example.katomaran_hackathon"
            
            // Facebook configuration
            manifestPlaceholders["facebookAppId"] = "@string/facebook_app_id"
            manifestPlaceholders["facebookClientToken"] = "" // Making client token optional
            manifestPlaceholders["fbLoginProtocolScheme"] = "@string/facebook_login_protocol_scheme"
            
            // Facebook SDK configuration
            buildConfigField("String", "FACEBOOK_APP_ID", "\"@string/facebook_app_id\"")
            buildConfigField("String", "FACEBOOK_CLIENT_TOKEN", "\"\"") // Empty client token
        }
    }
}

dependencies {
    // Add Facebook SDK
    implementation("com.facebook.android:facebook-login:latest.release")
    implementation("com.facebook.android:facebook-android-sdk:latest.release")
}
