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
            
            // Add these lines
            manifestPlaceholders["facebookAppId"] = "@string/facebook_app_id"
            manifestPlaceholders["facebookClientToken"] = "@string/facebook_client_token"
            manifestPlaceholders["fbLoginProtocolScheme"] = "fb${facebook_app_id}"
            
            // Add this if you're using Facebook SDK v12.0.0 or higher
            buildConfigField("String", "FACEBOOK_APP_ID", '"@string/facebook_app_id"')
            buildConfigField("String", "FACEBOOK_CLIENT_TOKEN", '"@string/facebook_client_token"')
        }
    }
}

dependencies {
    // Add Facebook SDK
    implementation("com.facebook.android:facebook-login:latest.release")
    implementation("com.facebook.android:facebook-android-sdk:latest.release")
}
