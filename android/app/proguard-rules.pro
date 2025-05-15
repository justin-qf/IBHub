############## FLUTTER WRAPPER ##############
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.editing.** { *; }
-dontwarn io.flutter.**

# Dart entry point
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

############## FLUTTER ENGINE & CHANNELS ##############
-keep class io.flutter.embedding.engine.FlutterEngine { *; }
-keep class io.flutter.embedding.engine.dart.DartExecutor { *; }
-keep class io.flutter.plugin.common.MethodChannel { *; }
-keep class io.flutter.plugin.common.EventChannel { *; }

############## SMART AUTH ##############
-keep class fman.ge.smart_auth.** { *; }
-dontwarn fman.ge.smart_auth.**

############## PLAY CORE ##############
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

############## MAIN ACTIVITY ##############
-keep class com.example.ibh.MainActivity { *; }

############## FIREBASE ##############
-keep class com.google.firebase.** { *; }
-keep class com.firebase.** { *; }
-dontwarn com.google.firebase.**
-keepnames class com.google.firebase.crashlytics.** { *; }
-dontwarn com.google.firebase.crashlytics.**
-keep class com.google.firebase.components.ComponentRegistrar { *; }

############## GOOGLE SERVICES ##############
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

############## LIFECYCLE ##############
-keep class androidx.lifecycle.DefaultLifecycleObserver
-keep class androidx.lifecycle.LifecycleObserver
-keep class androidx.lifecycle.LifecycleOwner
-keep class androidx.lifecycle.ProcessLifecycleOwner

############## JSON / GSON ##############
-keep class com.google.gson.** { *; }
-keep class com.google.gson.stream.** { *; }
-dontwarn com.google.gson.**
-keepnames class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

############## COMMON ANNOTATIONS ##############
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

############## KEEP CONSTRUCTORS ##############
-keepclassmembers class * {
    public <init>(...);
}

############## ANDROIDX KEEP ##############
-keep class androidx.** { *; }
-dontwarn androidx.**

############## REFLECTION SAFETY FOR MODELS ##############
-keep class **.model.** { *; }  # Optional - only if you use models for parsing

############## KOTLIN REFLECTION ##############
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**

############## MISC ##############
-dontwarn javax.annotation.**
-dontwarn org.codehaus.mojo.animal_sniffer.*
-dontwarn org.checkerframework.**
-dontwarn com.squareup.okhttp.**
-dontwarn retrofit2.Platform$Java8
