pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
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
    // AGP 9.1.1+ is required for compileSdk 37 (9.0 tops out at API 36.1, 8.13.2
    // at API 36). Flutter SDK 3.44 still unconditionally auto-applies
    // kotlin-android to plugin subprojects, which conflicts with AGP 9's built-in
    // Kotlin and new DSL, so android.builtInKotlin and android.newDsl are both
    // off in gradle.properties — keep them that way while on Flutter 3.44.
    // See https://github.com/flutter/flutter/issues/186795 and
    //     https://github.com/flutter/flutter/issues/186800
    id("com.android.application") version "9.3.1" apply false
    id("org.jetbrains.kotlin.android") version "2.4.20" apply false
}

include(":app")
