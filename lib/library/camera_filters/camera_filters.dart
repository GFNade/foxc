// ignore_for_file: must_be_immutable

// library camera_filters;

import 'dart:async';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:camera/camera.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/common/controller/base_controller.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/library/camera_filters/result_view.dart';
import 'package:untitled/library/camera_filters/src/filters.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/extra_views/back_button.dart';
import 'package:untitled/screens/extra_views/buttons.dart';
import 'package:untitled/utilities/const.dart';
import 'package:video_player/video_player.dart';

class CameraScreenPlugin extends StatefulWidget {
  /// this function will return the path of edited picture
  Function(String fileURL, double duration)? onDone;

  /// this function will return the path of edited video
  Function(String fileURL, double duration)? onVideoDone;

  /// list of filters
  List<Color>? filters;

  bool applyFilters;

  /// notify color to change
  ValueNotifier<Color>? filterColor;

  ///circular gradient color
  List<Color>? gradientColors;

  /// profile widget if you want to use profile widget on camera
  Widget? profileIconWidget;

  /// profile widget if you want to use profile widget on camera
  Widget? sendButtonWidget;

  CameraScreenPlugin(
      {Key? key,
      this.onDone,
      this.onVideoDone,
      this.filters,
      this.profileIconWidget,
      this.applyFilters = true,
      this.gradientColors,
      this.sendButtonWidget,
      this.filterColor})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreenPlugin> with WidgetsBindingObserver {
  ///animation controller for circular progress indicator

  /// Camera Controller
  CameraController? _controller;

  /// initializer of controller
  Future<void>? _initializeControllerFuture;

  /// flash mode changer
  ValueNotifier<int> flashCount = ValueNotifier(0);

  /// flash mode changer
  ValueNotifier<String> time = ValueNotifier("");

  /// condition check that picture is taken or not
  bool capture = false;

  ///Timer initialize
  Timer? t;

  /// camera list, this list will tell user that he/she is on front camera or back
  List<CameraDescription> cameras = [];

  /// bool to change picture to video or video to picture

  ///list of filters color
  final _filters = [
    Colors.transparent,
    ...List.generate(
      Colors.primaries.length,
      (index) => Colors.primaries[(index) % Colors.primaries.length],
    )
  ];

  ///filter color notifier
  final _filterColor = ValueNotifier<Color>(Colors.transparent);

  ///filter color change function
  void _onFilterChanged(Color value) {
    widget.filterColor == null ? _filterColor.value = value : widget.filterColor!.value = value;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    flashCount.value = 0;
    if (widget.filterColor != null) {
      widget.filterColor = ValueNotifier<Color>(Colors.transparent);
    }
    initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  showInSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
  }

  ///timer Widget
  timer() {
    t = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      time.value = timer.tick.toString();
    });
  }

  ///timer function
  String formatHHMMSS(int milliseconds) {
    int seconds = milliseconds ~/ 100;
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  ///this function will initialize camera
  initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();

    /// this condition check that camera is available on your device
    cameras = await availableCameras();

    ///put camera in camera controller
    _controller = cameras.isEmpty
        ? null
        : CameraController(
            cameras[0],
            ResolutionPreset.high,
          );

    _initializeControllerFuture = _controller?.initialize().then((_) async {
      await _controller?.lockCaptureOrientation(DeviceOrientation.portraitUp);
      await _controller?.prepareForVideoRecording();

      if (!mounted) {
        return;
      }
      flashCount.value = 0;
      await _controller?.setFlashMode(FlashMode.off);
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            print(e.description ?? '');
            // Handle other errors here.
            break;
        }
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      _controller?.setFlashMode(FlashMode.off);
      setState(() {});
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cBlack,
      child: _initializeControllerFuture == null
          ? const Center(child: CircularProgressIndicator(color: cPrimary))
          : Stack(
              children: [
                FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      /// If the Future is complete, display the preview.
                      return ValueListenableBuilder(
                          valueListenable: widget.filterColor ?? _filterColor,
                          builder: (context, value, child) {
                            return ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  widget.filterColor == null ? _filterColor.value : widget.filterColor!.value,
                                  BlendMode.softLight),
                              child: _controller != null
                                  ? Transform.scale(
                                      scale: 1 /
                                          ((_controller?.value.aspectRatio ?? 0) *
                                              MediaQuery.of(context).size.aspectRatio),
                                      alignment: Alignment.topCenter,
                                      child: CameraPreview(_controller!),
                                    )
                                  : Container(),
                            );
                          });
                    } else {
                      return const Center(child: CircularProgressIndicator(color: cPrimary));
                    }
                  },
                ),
                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      topBar(),
                      const Spacer(),
                      ValueListenableBuilder(
                        valueListenable: time,
                        builder: (context, value, child) {
                          return Opacity(opacity: value == '' ? 1 : 0.5, child: _buildFilterSelector());
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget topBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (flashCount.value == 0) {
                flashCount.value = 1;

                _controller?.setFlashMode(FlashMode.torch);

                /// if flash count is one flash will on
              } else if (flashCount.value == 1) {
                flashCount.value = 2;

                _controller?.setFlashMode(FlashMode.auto);
              }

              /// if flash count is two flash will auto
              else {
                flashCount.value = 0;

                _controller?.setFlashMode(FlashMode.off);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: const BoxDecoration(color: cBlack, shape: BoxShape.circle),
              child: ValueListenableBuilder(
                  valueListenable: flashCount,
                  builder: (context, value, Widget? c) {
                    return Icon(
                      size: 25,
                      flashCount.value == 0
                          ? Icons.flash_off_rounded
                          : flashCount.value == 1
                              ? Icons.flash_on_rounded
                              : Icons.flash_auto_rounded,
                      color: cPrimary,
                    );
                  }),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          button(
            Icons.cameraswitch_rounded,
            () {
              if (_controller?.description.lensDirection == CameraLensDirection.front) {
                final CameraDescription selectedCamera = cameras[0];
                _initCameraController(selectedCamera);
              } else {
                final CameraDescription selectedCamera = cameras[1];
                _initCameraController(selectedCamera);
              }
            },
          ),
          const SizedBox(
            width: 5,
          ),
          button(
            Icons.photo_library_outlined,
            () {
              Get.bottomSheet(StoryImagePicker(
                imageSource: ImageSource.gallery,
                onGetPath: (path, isVideo) {
                  Get.to(() => ResultView(
                      isVideo: isVideo,
                      fileURL: path,
                      onDone: widget.onVideoDone,
                      color: Colors.transparent))?.then((value) {
                    if (flashCount.value == 1) {
                      _controller?.setFlashMode(FlashMode.torch);
                    }
                  });
                },
              ));
            },
          ),
          const SizedBox(
            width: 5,
          ),
          const Spacer(),
          ValueListenableBuilder(
              valueListenable: time,
              builder: (context, value, Widget? c) {
                return time.value == ""
                    ? Container()
                    : Container(
                        decoration: const ShapeDecoration(
                            shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius.all(
                                    SmoothRadius(cornerRadius: 12, cornerSmoothing: cornerSmoothing))),
                            color: cBlack),
                        padding: const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 3),
                        child: Text(
                          formatHHMMSS(int.parse(time.value)),
                          style: MyTextStyle.gilroyBold(color: cPrimary),
                        ),
                      );
              })
        ],
      ),
    );
  }

  Widget button(IconData iconData, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: const BoxDecoration(color: cBlack, shape: BoxShape.circle),
        child: Icon(
          size: 25,
          iconData,
          color: cPrimary,
        ),
      ),
    );
  }

  flashCheck() {
    if (flashCount.value == 1) {
      _controller?.setFlashMode(FlashMode.off);
    }
  }

  /// function will call when user tap on picture button
  void onTakePictureButtonPressed(context) {
    takePicture(context).then((String? filePath) async {
      if (_controller?.value.isInitialized == true) {
        if (filePath != null) {
          var color = widget.filterColor == null ? _filterColor.value : widget.filterColor!.value;
          Get.to(() => ResultView(
                isVideo: false,
                color: color,
                onDone: widget.onDone,
                fileURL: filePath,
              ))?.then((value) {
            if (flashCount.value == 1) {
              _controller?.setFlashMode(FlashMode.torch);
            }
          });
          flashCheck();
        }
      }
    });
  }

  Future<String> takePicture(context) async {
    if (_controller?.value.isInitialized == false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: camera is not initialized')));
    }
    final dirPath = await getTemporaryDirectory();
    String filePath = '${dirPath.path}/${timestamp()}.jpg';

    try {
      final picture = await _controller?.takePicture();
      filePath = picture?.path ?? '';
    } on CameraException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.description}')));
    }
    return filePath;
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  /// widget will build the filter selector
  Widget _buildFilterSelector() {
    return FilterSelector(
      onFilterChanged: _onFilterChanged,
      filters: widget.applyFilters == false ? [] : widget.filters ?? _filters,
      onTap: () {
        if (capture == false) {
          capture = true;
          onTakePictureButtonPressed(context);
          Future.delayed(const Duration(seconds: 3), () {
            capture = false;
          });
        }
      },
      onLongPress: () async {
        await _controller?.startVideoRecording(
          onAvailable: (image) {
            int seconds = int.parse(time.value) ~/ 100;
            if (seconds == ((SessionManager.shared.getSettings()?.minuteLimitInCreatingStory ?? 0) * 60)) {
              stopRecording();
            }
          },
        );
        timer();
      },
      onLongPressEnd: (v) async {
        await stopRecording();
      },
    );
  }

  Future stopRecording() async {
    t?.cancel();
    time.value = "";
    final file = await _controller?.stopVideoRecording();
    flashCheck();
    var color = widget.filterColor == null ? _filterColor.value : widget.filterColor!.value;
    Get.to(() => ResultView(isVideo: true, fileURL: file?.path ?? '', onDone: widget.onVideoDone, color: color))
        ?.then((value) {
      if (flashCount.value == 1) {
        _controller?.setFlashMode(FlashMode.torch);
      }
    });
  }

  /// function initialize camera controller
  Future _initCameraController(CameraDescription cameraDescription) async {
    _controller = CameraController(cameraDescription, ResolutionPreset.high);
    _controller?.addListener(() {
      if (_controller?.value.hasError == true) {
        print('Camera error ${_controller?.value.errorDescription}');
      }
    });
    try {
      await _controller?.initialize();
    } on CameraException catch (e) {
      print(e);
    }
    setState(() {});
  }
}

class StoryImagePicker extends StatelessWidget {
  final ImageSource imageSource;

  final Function(String path, bool isVideo) onGetPath;

  const StoryImagePicker({super.key, required this.imageSource, required this.onGetPath});

  @override
  Widget build(BuildContext context) {
    final imagePicker = ImagePicker();
    return Wrap(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: cBlack,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          padding: const EdgeInsets.all(25),
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Spacer(),
                    XMarkButton(),
                  ],
                ),
                Text(
                  LKeys.howDoYouWant.tr,
                  style: MyTextStyle.gilroyBold(size: 22, color: cWhite),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    btn(
                        title: LKeys.image,
                        onTap: () async {
                          XFile? file = await imagePicker.pickImage(source: imageSource);
                          print(file?.path);
                          if (file != null) {
                            Get.back();
                            onGetPath(file.path, false);
                          }
                        }),
                    const SizedBox(
                      width: 10,
                    ),
                    btn(
                      title: LKeys.video,
                      onTap: () async {
                        XFile? file = await imagePicker.pickVideo(source: imageSource);
                        VideoPlayerController testLengthController =
                            new VideoPlayerController.file(File(file?.path ?? '')); //Your file here
                        await testLengthController.initialize();
                        var limit = (SessionManager.shared.getSettings()?.minuteLimitInChoosingVideoForStory ?? 0);
                        if (testLengthController.value.duration.inSeconds > limit * 60) {
                          BaseController.share.showSnackBar('${LKeys.weAreOnlyAllow.tr} $limit ${LKeys.minute.tr}',
                              type: SnackBarType.error);
                        } else {
                          if (file != null) {
                            Get.back();
                            onGetPath(file.path, true);
                          }
                        }
                        testLengthController.dispose();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget btn({required String title, required Function() onTap}) {
    return Expanded(
      child: CommonSheetButton(
        title: title.tr,
        onTap: onTap,
      ),
    );
  }
}
