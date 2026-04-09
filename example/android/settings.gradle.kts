pluginManagement {
    val flutterSdkPath =
        run {
            val localProperties = java.util.Properties()
            val localPropertiesFile = file("local.properties")
            if (localPropertiesFile.exists()) {
                localPropertiesFile.inputStream().use { localProperties.load(it) }
                localProperties.getProperty("flutter.sdk")
            } else {
                System.getenv("FLUTTER_ROOT") ?: System.getenv("FLUTTER_HOME")
            } ?: error(
                "Flutter SDK path not found. Set flutter.sdk in local.properties or define FLUTTER_ROOT."
            )
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
