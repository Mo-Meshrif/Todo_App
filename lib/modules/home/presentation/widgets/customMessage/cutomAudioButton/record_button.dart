import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../../../../../app/utils/constants_manager.dart';
import '../../../../../../app/utils/strings_manager.dart';
import 'flow_shader.dart';
import 'lottie_animation.dart';

class RecordButton extends StatefulWidget {
  final Function(bool tapStatus) getTapStatus;
  final Function(String? recordPath) sendRecord;
  const RecordButton({
    Key? key,
    required this.getTapStatus,
    required this.sendRecord,
  }) : super(key: key);

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  static const double size = 45;

  final double lockerHeight = 200;
  double timerWidth = 0;

  late Animation<double> buttonScaleAnimation;
  late Animation<double> timerAnimation;
  late Animation<double> lockerAnimation;
  String documentPath = '';
  String? filePath;
  DateTime? startTime;
  Timer? timer;
  String recordDuration = "00:00";
  Record record = Record();

  bool isLocked = false;
  bool showLottie = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    buttonScaleAnimation = Tween<double>(begin: 1, end: 2).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticInOut),
      ),
    );
    getDocumentPath();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timerWidth = MediaQuery.of(context).size.width - 2 * 8 - 4;
    timerAnimation = Tween<double>(begin: timerWidth + 8, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
    lockerAnimation = Tween<double>(begin: lockerHeight + 80, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    record.dispose();
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  getDocumentPath() async =>
      documentPath = (await getApplicationDocumentsDirectory()).path + "/";

  @override
  Widget build(BuildContext context) {
    return isLocked
        ? Expanded(
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {
                    Vibrate.feedback(FeedbackType.heavy);
                    timer?.cancel();
                    timer = null;
                    startTime = null;
                    recordDuration = "00:00";
                    filePath = await record.stop();
                    debugPrint(filePath);
                    File(filePath!).delete();
                    setState(() {
                      isLocked = false;
                    });
                    widget.getTapStatus(false);
                  },
                  icon: const Icon(Icons.delete),
                ),
                Expanded(child: timerLocked()),
                const SizedBox(width: 10),
              ],
            ),
          )
        : Stack(
            clipBehavior: Clip.none,
            children: [
              lockSlider(),
              cancelSlider(),
              audioButton(),
            ],
          );
  }

  Widget lockSlider() {
    return Positioned(
      bottom: -lockerAnimation.value,
      child: Container(
        height: lockerHeight,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          color: Colors.grey[200],
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.lock, size: 20),
            const SizedBox(height: 8),
            FlowShader(
              direction: Axis.vertical,
              child: Column(
                children: const [
                  Icon(Icons.keyboard_arrow_up),
                  Icon(Icons.keyboard_arrow_up),
                  Icon(Icons.keyboard_arrow_up),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cancelSlider() {
    bool arabic = context.locale == AppConstants.arabic;
    return Positioned(
      right: arabic ? null : -timerAnimation.value,
      left: arabic ? -timerAnimation.value : null,
      child: Container(
        height: size,
        width: timerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          color: Colors.grey[200],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              showLottie ? const LottieAnimation() : Text(recordDuration),
              const SizedBox(width: size),
              FlowShader(
                child: Row(
                  children: [
                    Icon(
                      arabic
                          ? Icons.keyboard_arrow_right
                          : Icons.keyboard_arrow_left,
                    ),
                    const Text(AppStrings.slideCancel).tr()
                  ],
                ),
                duration: const Duration(seconds: 3),
                flowColors: const [Colors.white, Colors.grey],
              ),
              const SizedBox(width: size),
            ],
          ),
        ),
      ),
    );
  }

  Widget timerLocked() {
    return Container(
      height: size,
      width: timerWidth,
      padding: const EdgeInsets.only(left: 15, right: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        color: Colors.grey[200],
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          Vibrate.feedback(FeedbackType.success);
          timer?.cancel();
          timer = null;
          startTime = null;
          recordDuration = "00:00";
          filePath = await record.stop();
          widget.sendRecord(filePath);
          setState(() {
            isLocked = false;
          });
          widget.getTapStatus(false);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(recordDuration),
            FlowShader(
              child: const Text(AppStrings.tapLock).tr(),
              duration: const Duration(seconds: 3),
              flowColors: const [Colors.white, Colors.grey],
            ),
            const Center(
              child: Icon(
                Icons.lock,
                size: 18,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget audioButton() {
    return GestureDetector(
      child: Transform.scale(
        scale: buttonScaleAnimation.value,
        child: Container(
          child: const Icon(Icons.mic),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: size,
          width: size,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      onTap: () async {
        debugPrint("ontapPress");
        if (await record.hasPermission()) {
          if (documentPath.isNotEmpty) {
            setState(() {
              isLocked = true;
            });
            widget.getTapStatus(true);
            await record.start(
              path: documentPath +
                  "audio_${DateTime.now().millisecondsSinceEpoch}.m4a",
              encoder: AudioEncoder.AAC,
              bitRate: 128000,
              samplingRate: 44100,
            );
            startTime = DateTime.now();
            timer = Timer.periodic(const Duration(seconds: 1), (_) {
              final minDur = DateTime.now().difference(startTime!).inMinutes;
              final secDur =
                  DateTime.now().difference(startTime!).inSeconds % 60;
              String min = minDur < 10 ? "0$minDur" : minDur.toString();
              String sec = secDur < 10 ? "0$secDur" : secDur.toString();
              setState(() {
                recordDuration = "$min:$sec";
              });
            });
          }
        }
      },
      onLongPressDown: (_) {
        debugPrint("onLongPressDown");
        controller.forward();
      },
      onLongPressEnd: (details) async {
        debugPrint("onLongPressEnd");
        if (isCancelled(details.localPosition, context)) {
          Vibrate.feedback(FeedbackType.heavy);
          timer?.cancel();
          timer = null;
          startTime = null;
          recordDuration = "00:00";
          setState(() {
            showLottie = true;
          });
          Timer(const Duration(milliseconds: 1440), () async {
            controller.reverse();
            debugPrint("Cancelled recording");
            filePath = await record.stop();
            debugPrint(filePath);
            File(filePath!).delete();
            debugPrint("Deleted $filePath");
            showLottie = false;
          });
        } else if (checkIsLocked(details.localPosition)) {
          controller.reverse();
          Vibrate.feedback(FeedbackType.heavy);
          debugPrint("Locked recording");
          debugPrint(details.localPosition.dy.toString());
          setState(() {
            isLocked = true;
          });
        } else {
          controller.reverse();
          Vibrate.feedback(FeedbackType.success);
          timer?.cancel();
          timer = null;
          startTime = null;
          recordDuration = "00:00";
          await record.stop();
        }
        widget.getTapStatus(isLocked);
      },
      onLongPressCancel: () {
        debugPrint("onLongPressCancel");
        controller.reverse();
      },
      onLongPress: () async {
        debugPrint("onLongPress");
        Vibrate.feedback(FeedbackType.success);
        if (await record.hasPermission()) {
          if (await record.isRecording() == false) {
            if (documentPath.isNotEmpty) {
              await record.start(
                path: documentPath +
                    "audio_${DateTime.now().millisecondsSinceEpoch}.m4a",
                encoder: AudioEncoder.AAC,
                bitRate: 128000,
                samplingRate: 44100,
              );
              startTime = DateTime.now();
              timer = Timer.periodic(const Duration(seconds: 1), (_) {
                final minDur = DateTime.now().difference(startTime!).inMinutes;
                final secDur =
                    DateTime.now().difference(startTime!).inSeconds % 60;
                String min = minDur < 10 ? "0$minDur" : minDur.toString();
                String sec = secDur < 10 ? "0$secDur" : secDur.toString();
                setState(() {
                  recordDuration = "$min:$sec";
                });
              });
            }
          }
        }
      },
    );
  }

  bool checkIsLocked(Offset offset) {
    return (offset.dy < -35);
  }

  bool isCancelled(Offset offset, BuildContext context) {
    return (offset.dx < -(MediaQuery.of(context).size.width * 0.2));
  }
}
