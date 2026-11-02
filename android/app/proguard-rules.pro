# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /Users/montu/.../proguard-android.txt
-keepattributes *Annotation*
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

