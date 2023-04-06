import 'package:favmusic/views/home.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  bool isStorageAccess = false;
  var playIndex = 0.obs;
  var isPlaying = false.obs;
  var duration = "".obs;
  var position = "".obs;
  var max = 0.0.obs;
  var value = 0.0.obs;
  @override
  void onInit() {
    super.onInit();
    if (isStorageAccess == false) {
      checkPermission();
    }
  }

  updatePosition() {
    audioPlayer.durationStream.listen((dd) {
      duration.value = dd.toString().split(".")[0];
      max.value = dd!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((am) {
      position.value = am.toString().split(".")[0];
      value.value = am.inSeconds.toDouble();
    });
  }

  changeDurationToSeconds(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  onComplete( ) {
    
    audioPlayer.setLoopMode(LoopMode.all);
  }

  playSong(String? uri, index) {
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(uri!),
        ),
      );
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
      onComplete();
    } on Exception catch (e) {
      print((e.toString()));
    }
  }

  checkPermission() async {
    var perm = await Permission.storage.request();

    if (perm.isGranted) {
      isStorageAccess = true;
      Get.offAll(() => Home());
    } else {
      checkPermission();
    }
  }
}
