import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.transgoapp.transgomobileapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.transgoapp.transgomobileapp"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = 37
        versionName = "1.1.0"
    }

    signingConfigs {
        if (keystorePropertiesFile.exists() && keystoreProperties.containsKey("storeFile")) {
            create("release") {
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    buildTypes {
        release {
            if (keystorePropertiesFile.exists() && keystoreProperties.containsKey("storeFile")) {
                signingConfig = signingConfigs.getByName("release")
            }
            isMinifyEnabled = false
            isShrinkResources = false
        }

        debug {
            isMinifyEnabled = false
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
