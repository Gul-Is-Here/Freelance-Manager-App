plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.freelance_manager.app"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.freelance_manager.app"
        minSdk = 23
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Correct spelling here
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
