package com.example.onsetway_services

import android.app.Application
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.FlutterEngineCache

class MyApplication : Application() {
    override fun onCreate() {
        super.onCreate()

        // أنشئ محرك Flutter واحد ودشّنه مبكراً
        val engine = FlutterEngine(this)
        engine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        // خزّنه بهوية ثابتة لاستخدامه لاحقاً في MainActivity
        FlutterEngineCache
            .getInstance()
            .put("main_engine", engine)
    }
}
