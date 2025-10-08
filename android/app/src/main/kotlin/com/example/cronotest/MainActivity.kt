package com.example.cronotest

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import android.util.Log

class MainActivity: FlutterActivity() {
    private val CHANNEL = "ffmpeg_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "extractFrames") {
                val videoPath = call.argument<String>("videoPath") ?: ""
                val outputDir = call.argument<String>("outputDir") ?: ""
                val intervalSeconds = call.argument<Int>("intervalSeconds") ?: 1

                val command = "-i $videoPath -vf fps=1/$intervalSeconds $outputDir/frame_%03d.jpg"

                try {
                    val process = Runtime.getRuntime().exec(arrayOf("ffmpeg", *command.split(" ").toTypedArray()))
                    process.waitFor()
                    result.success("Frames extraídos com sucesso")
                } catch (e: Exception) {
                    result.error("FFMPEG_ERROR", "Erro ao executar FFmpeg: ${e.message}", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}