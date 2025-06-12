# إصلاح مشكلة camera-core
-dontwarn androidx.camera.**
-keep class androidx.camera.** { *; }

# إبقاء الميثود اللي عامل المشكلة
-keepclassmembers class * {
    void androidx.camera.core.internal.CameraUseCaseAdapter.updateViewPort(java.util.List);
}
