import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  AudioPlayer? _audioPlayer;

  AudioService._internal();

  Future<void> playSound(String soundPath) async {
    try {
      // 每次播放创建新的播放器实例
      _audioPlayer?.dispose();
      _audioPlayer = AudioPlayer();

      await _audioPlayer?.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer?.setSourceAsset(soundPath);
      await _audioPlayer?.resume();
    } catch (e) {
      debugPrint('播放音频失败: $e');
    }
  }

  void dispose() {
    _audioPlayer?.dispose();
    _audioPlayer = null;
  }
}
