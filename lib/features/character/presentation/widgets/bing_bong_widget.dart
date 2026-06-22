import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thermion_flutter/thermion_flutter.dart';

import '../../logic/character_notifier.dart';
import 'shockwave.dart';

class CharacterOrbitController {
  _BingBongModelState? _state;

  void rotate(double deltaYaw, double deltaPitch) =>
      _state?._applyDrag(deltaYaw, deltaPitch);

  void release() => _state?._release();
}

class BingBongWidget extends ConsumerStatefulWidget {
  final ShockwaveController? shockwave;

  const BingBongWidget({super.key, this.shockwave});

  @override
  ConsumerState<BingBongWidget> createState() => _BingBongWidgetState();
}

class _BingBongWidgetState extends ConsumerState<BingBongWidget>
    with TickerProviderStateMixin {
  static const double _modelSize = 280;
  static const double _dragSensitivity = 0.011;

  late final AnimationController _floatController;
  late final AnimationController _breathController;
  late final AnimationController _bounceController;
  late final AnimationController _wobbleController;

  late final Animation<double> _floatAnim;
  late final Animation<double> _breathAnim;
  late final Animation<double> _scaleY;
  late final Animation<double> _scaleX;

  final CharacterOrbitController _orbit = CharacterOrbitController();
  late final Widget _modelViewport;

  @override
  void initState() {
    super.initState();

    _modelViewport = SizedBox(
      width: _modelSize,
      height: _modelSize,
      child: BingBongModel(orbit: _orbit),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat(reverse: true);

    _breathAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    );

    _scaleY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.88,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 14,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.88,
          end: 1.20,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 22,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.20,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 64,
      ),
    ]).animate(_bounceController);

    _scaleX = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.10,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 14,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.10,
          end: 0.86,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 22,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.86,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 64,
      ),
    ]).animate(_bounceController);

    _wobbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _breathController.dispose();
    _bounceController.dispose();
    _wobbleController.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    HapticFeedback.mediumImpact();
    widget.shockwave?.pulse();

    _bounceController.forward(from: 0);
    _wobbleController.forward(from: 0);

    await ref.read(characterProvider.notifier).onTap();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _orbit.rotate(
      details.delta.dx * _dragSensitivity,
      -details.delta.dy * _dragSensitivity,
    );
  }

  void _onPanEnd(DragEndDetails details) => _orbit.release();

  double _wobbleRad(double w) {
    if (w == 0) return 0;
    final decay = math.pow(1 - w, 1.8).toDouble();
    return math.sin(w * math.pi * 3.0) * 0.045 * decay;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _floatController,
          _breathController,
          _bounceController,
          _wobbleController,
        ]),
        builder: (context, child) {
          final breathT = _breathAnim.value;
          final breathY = 1.0 + breathT * 0.018;
          final breathX = 1.0 - breathT * 0.012;

          final sy = _scaleY.value * breathY;
          final sx = _scaleX.value * breathX;

          return Transform.translate(
            offset: Offset(0, _floatAnim.value),
            child: Transform.rotate(
              angle: _wobbleRad(_wobbleController.value),
              child: Transform.scale(
                scaleX: sx,
                scaleY: sy,
                alignment: Alignment.bottomCenter,
                child: child,
              ),
            ),
          );
        },
        child: _modelViewport,
      ),
    );
  }
}

class BingBongModel extends StatefulWidget {
  final CharacterOrbitController? orbit;

  const BingBongModel({super.key, this.orbit});

  @override
  State<BingBongModel> createState() => _BingBongModelState();
}

class _BingBongModelState extends State<BingBongModel>
    with SingleTickerProviderStateMixin {
  static const String _modelAsset = 'assets/models/peak-bingbong-model.glb';
  static const String _iblAsset = 'assets/models/default_env_ibl.ktx';

  static const double _fill = 1.1;
  static const double _fallbackTanHalfFov = 0.2;
  static const double _maxPitch = 1.2;

  ThermionViewer? _viewer;
  ThermionAsset? _asset;
  Widget? _surface;

  Matrix4 _baseTransform = Matrix4.identity();
  Vector3 _center = Vector3.zero();

  double _yaw = 0;
  double _pitch = 0;
  bool _applying = false;

  late final AnimationController _returnController;
  double _returnFromYaw = 0;
  double _returnFromPitch = 0;

  @override
  void initState() {
    super.initState();
    widget.orbit?._state = this;
    _returnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(_onReturnTick);
    _setup();
  }

  Future<void> _setup() async {
    final viewer = await ThermionFlutterPlugin.createViewer();
    _viewer = viewer;

    final asset = await viewer.loadGltf(_modelAsset);
    _asset = asset;
    _baseTransform = await asset.getLocalTransform();
    _center = (await _worldBoundingBox(viewer, asset)).center;
    await viewer.loadIbl(_iblAsset);
    await viewer.setPostProcessing(true);
    await viewer.setAntiAliasing(false, true, false);

    await _frameCamera(_fallbackTanHalfFov);

    await viewer.setRendering(true);
    await viewer.setBackgroundColor(0, 0, 0, 0);

    if (!mounted) return;
    setState(() {
      _surface = ThermionWidget(
        viewer: viewer,
        initial: const SizedBox.shrink(),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _reframeToLens());
  }

  Future<void> _frameCamera(double tanHalfFov) async {
    final viewer = _viewer;
    final asset = _asset;
    if (viewer == null || asset == null) return;

    final bb = await _worldBoundingBox(viewer, asset);
    final size = bb.max - bb.min;
    final center = bb.center;

    final radius = math.max(size.x, size.y) * 0.5;
    final distance = radius / (_fill * tanHalfFov);

    final camera = await viewer.getActiveCamera();
    await camera.lookAt(
      Vector3(center.x, center.y, center.z + distance),
      focus: Vector3(center.x, center.y, center.z),
    );
  }

  Future<Aabb3> _worldBoundingBox(
    ThermionViewer viewer,
    ThermionAsset asset,
  ) async {
    Aabb3? bounds;
    for (final entity in await asset.getChildEntities()) {
      final local = await viewer.getRenderableBoundingBox(entity);
      final extent = local.max - local.min;
      if (extent.x <= 0 && extent.y <= 0 && extent.z <= 0) continue;

      final world = await asset.getWorldTransform(entity: entity);
      local.transform(world);

      if (bounds == null) {
        bounds = Aabb3.copy(local);
      } else {
        bounds.hull(local);
      }
    }
    return bounds ?? Aabb3();
  }

  void _applyDrag(double deltaYaw, double deltaPitch) {
    _returnController.stop();
    _yaw += deltaYaw;
    _pitch = (_pitch + deltaPitch).clamp(-_maxPitch, _maxPitch);
    _requestApply();
  }

  void _release() {
    _yaw = _shortestAngleToFront(_yaw);
    if (_yaw == 0 && _pitch == 0) return;
    _returnFromYaw = _yaw;
    _returnFromPitch = _pitch;
    _returnController.forward(from: 0);
  }

  double _shortestAngleToFront(double angle) {
    const fullTurn = 2 * math.pi;
    final wrapped = angle.remainder(fullTurn);
    if (wrapped > math.pi) return wrapped - fullTurn;
    if (wrapped < -math.pi) return wrapped + fullTurn;
    return wrapped;
  }

  void _onReturnTick() {
    final remaining =
        1.0 - Curves.easeOutCubic.transform(_returnController.value);
    _yaw = _returnFromYaw * remaining;
    _pitch = _returnFromPitch * remaining;
    _requestApply();
  }

  void _requestApply() {
    if (_applying) return;
    _applying = true;
    _drain();
  }

  Future<void> _drain() async {
    try {
      final asset = _asset;
      while (mounted && asset != null) {
        final yaw = _yaw;
        final pitch = _pitch;
        await asset.setTransform(_orbitTransform(yaw, pitch));
        if (yaw == _yaw && pitch == _pitch) break;
      }
    } finally {
      _applying = false;
    }
  }

  Matrix4 _orbitTransform(double yaw, double pitch) {
    final rotation = Matrix4.identity()
      ..rotateY(yaw)
      ..rotateX(pitch);
    return Matrix4.translationValues(_center.x, _center.y, _center.z) *
        rotation *
        Matrix4.translationValues(-_center.x, -_center.y, -_center.z) *
        _baseTransform;
  }

  Future<void> _reframeToLens() async {
    final viewer = _viewer;
    if (viewer == null) return;
    final camera = await viewer.getActiveCamera();

    for (var i = 0; i < 12 && mounted; i++) {
      final proj = await camera.getProjectionMatrix();
      final isPerspective = proj.entry(3, 2).abs() > 0.5;
      final m11 = proj.entry(1, 1).abs();
      if (isPerspective && m11 > 0.01) {
        await _frameCamera(1.0 / m11);
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  @override
  void dispose() {
    widget.orbit?._state = null;
    _returnController.dispose();
    _viewer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _surface ?? const SizedBox.shrink();
  }
}
