############## FLUTTER WRAPPER ##############
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.editing.** { *; }
-dontwarn io.flutter.**

# Keep Dart entry point
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

############## FIREBASE ##############
-keep class com.google.firebase.** { *; }
-keep class com.firebase.** { *; }
-dontwarn com.google.firebase.**

# Keep lifecycle (for FirebaseMessaging, etc.)
-keep class androidx.lifecycle.DefaultLifecycleObserver
-keep class androidx.lifecycle.LifecycleObserver
-keep class androidx.lifecycle.LifecycleOwner
-keep class androidx.lifecycle.ProcessLifecycleOwner

# Firebase annotations/reflection usage
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Keep Firebase internal models using Gson
-keep class com.google.gson.** { *; }
-keep class com.google.gson.stream.** { *; }
-dontwarn com.google.gson.**

# Used in Firebase + Crashlytics
-keepnames class com.google.firebase.crashlytics.** { *; }
-dontwarn com.google.firebase.crashlytics.**

############## GOOGLE SERVICES ##############
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

-keep class com.google.android.play.** { *; }
-dontwarn com.google.android.play.**

############## COMMON ANNOTATIONS ##############
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes InnerClasses
-keepattributes EnclosingMethod

############## REFLECTION SAFETY ##############
-keepnames class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

############## OTHER COMMON ISSUES ##############
# Support for dynamic method invocation (reflection)
-keepclassmembers class * {
    public <init>(...);
}

# Fix for Crashlytics initialization
-keep class com.google.firebase.components.ComponentRegistrar { *; }

# Workaround for R8 errors with some plugins
-dontwarn javax.annotation.**
-dontwarn org.codehaus.mojo.animal_sniffer.*
-dontwarn org.checkerframework.**
-dontwarn com.squareup.okhttp.**
-dontwarn retrofit2.Platform$Java8

