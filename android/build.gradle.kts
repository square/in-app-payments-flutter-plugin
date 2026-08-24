group = "com.squareup.sqip.flutter"
version = "1.4.0"

buildscript {
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:9.0.1")
    }
}

rootProject.allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://sdk.squareup.com/public/android")
        }
    }
}

plugins {
    id("com.android.library")
}

val minIapSdkVersion = "1.6.9"
val compileSdkVersionDefault = 36

android {
    val sqipCompileSdkVersion = if (rootProject.hasProperty("sqipCompileSdkVersion")) {
        rootProject.property("sqipCompileSdkVersion").toString().toInt()
    } else {
        compileSdkVersionDefault
    }

    compileSdk = sqipCompileSdkVersion

    namespace = "sqip.flutter"

    defaultConfig {
        minSdk = 28
    }

    lint {
        disable.add("InvalidPackage")
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

val sqipVersion = if (rootProject.hasProperty("sqipVersion")) {
    rootProject.property("sqipVersion").toString()
} else {
    minIapSdkVersion
}

dependencies {
    implementation("com.squareup.sdk.in-app-payments:card-entry:$sqipVersion")
    implementation("com.squareup.sdk.in-app-payments:google-pay:$sqipVersion")
    implementation("com.google.android.gms:play-services-wallet:19.1.0")
    implementation("com.squareup.sdk.in-app-payments:buyer-verification:$sqipVersion")
}