import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'eye_tracking_service.dart';

class EyeTrackerWidget extends StatefulWidget {
  final EyeTrackingMetrics metrics;
  const EyeTrackerWidget({super.key, required this.metrics});

  @override
  State<EyeTrackerWidget> createState() => _EyeTrackerWidgetState();
}

class _EyeTrackerWidgetState extends State<EyeTrackerWidget> {
  CameraController? _controller;
  late FaceDetector _detector;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final cameras = await availableCameras();
    final frontCamera =
    cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.low,
      enableAudio: false,
    );

    await _controller!.initialize();

    _detector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: true,
        enableClassification: true,
        performanceMode: FaceDetectorMode.accurate,
        minFaceSize: 0.15,
      ),
    );

    await _controller!.startImageStream((image) async {
      if (_processing || !mounted) return;
      _processing = true;

      final bytes = _concatenatePlanes(image);

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: _rotationFromSensor(
            _controller!.description.sensorOrientation,
          ),
          format: InputImageFormat.yuv420,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final faces = await _detector.processImage(inputImage);

      if (faces.isNotEmpty) {
        widget.metrics.processFace(faces.first);
      }

      _processing = false;
    });

    if (!mounted) return;
    setState(() {});
  }

  Uint8List _concatenatePlanes(CameraImage image) {
    final List<int> bytes = [];
    for (final Plane plane in image.planes) {
      bytes.addAll(plane.bytes);
    }
    return Uint8List.fromList(bytes);
  }

  InputImageRotation _rotationFromSensor(int sensorOrientation) {
    switch (sensorOrientation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  @override
  void dispose() {
    _controller?.stopImageStream();
    _controller?.dispose();
    _detector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return Positioned(
      right: 12,
      bottom: 12,
      child: SizedBox(
        width: 90,
        height: 120,
        child: CameraPreview(_controller!),
      ),
    );
  }
}
