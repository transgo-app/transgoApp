import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val keystoreProperties = Properties()
// Detect flavor from task names (e.g., :app:assembleSandboxRelease)
val taskNames = project.gradle.startParameter.taskNames
val flavor = if (taskNames.any { it.contains("sandbox", ignoreCase = true) }) "sandbox" else "production"
val keystorePropertiesFile = rootProject.file("key-$flavor.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
} else {
    // Fallback to old key.properties if it exists
    val fallbackFile = rootProject.file("key.properties")
    if (fallbackFile.exists()) {
        keystoreProperties.load(FileInputStream(fallbackFile))
    }
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
        // applicationId = "com.transgoapp.transgomobileapp" // Moved to flavors
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = 54
        versionName = "2.2.4"
    }

    flavorDimensions += "version"
    productFlavors {
        create("production") {
            dimension = "version"
            applicationId = "com.transgoapp.transgomobileapp"
            resValue("string", "app_name", "TransGo")
        }
        create("sandbox") {
            dimension = "version"
            applicationId = "com.transgo.sandboxclient"
            resValue("string", "app_name", "TransGo Sandbox")
        }
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
            // Optional: You can also assign signingConfig = signingConfigs.getByName("release") here if you want debug builds to be signed
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
