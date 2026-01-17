import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import 'package:web_socket_channel/web_socket_channel.dart';

class SevenTvDropShadow {
  final double xOffset;
  final double yOffset;
  final double radius;
  final Color color;

  const SevenTvDropShadow({
    required this.xOffset,
    required this.yOffset,
    required this.radius,
    required this.color,
  });

  SevenTvDropShadow scaled(double scale) {
    return SevenTvDropShadow(
      xOffset: xOffset * scale,
      yOffset: yOffset * scale,
      radius: radius * scale,
      color: color,
    );
  }
}

class SevenTvPaintStop {
  final Color color;
  final double position;

  const SevenTvPaintStop({
    required this.color,
    required this.position,
  });
}

class SevenTvPaint {
  final String function;
  final bool repeat;
  final double? angle;
  final String? shape;
  final String? imageUrl;
  final List<SevenTvPaintStop> stops;
  final List<SevenTvDropShadow> dropShadows;

  const SevenTvPaint({
    required this.function,
    required this.repeat,
    required this.stops,
    this.angle,
    this.shape,
    this.imageUrl,
    this.dropShadows = const [],
  });
}

class SevenTvCosmeticsState {
  final Map<int, List<twitch.Badge>> badgesByTwitchUserId;
  final Map<int, SevenTvPaint> paintsByTwitchUserId;
  final Set<int> subscribedChannelIds;

  const SevenTvCosmeticsState({
    required this.badgesByTwitchUserId,
    required this.paintsByTwitchUserId,
    required this.subscribedChannelIds,
  });

  factory SevenTvCosmeticsState.initial() => const SevenTvCosmeticsState(
        badgesByTwitchUserId: {},
        paintsByTwitchUserId: {},
        subscribedChannelIds: <int>{},
      );
}

class SevenTvCosmeticsCubit extends Cubit<SevenTvCosmeticsState> {
  SevenTvCosmeticsCubit() : super(SevenTvCosmeticsState.initial()) {}

  static const _wsUrl = 'wss://events.7tv.io/v3';

  WebSocketChannel? _socket;
  StreamSubscription? _socketSub;

  int _lastHeartbeat = 0;
  int _expectedHeartbeatInterval = 0;
  int _heartbeatFailedCount = 0;
  Timer? _heartbeatTimer;
  bool _connectedOnce = false;

  final Map<String, Map<String, dynamic>> _cosmeticsById = {};
  final Map<String, List<Map<String, dynamic>>> _entitlementsByCosmeticId = {};
  final Set<String> _emittedUserCosmeticKeys = {};

  void subscribeToChannelId(int channelId) {
    if (state.subscribedChannelIds.contains(channelId)) return;
    emit(
      SevenTvCosmeticsState(
        badgesByTwitchUserId: state.badgesByTwitchUserId,
        paintsByTwitchUserId: state.paintsByTwitchUserId,
        subscribedChannelIds: {...state.subscribedChannelIds, channelId},
      ),
    );
    _ensureConnected();
    _subscribeChannel(channelId);
  }

  @override
  Future<void> close() async {
    _heartbeatTimer?.cancel();
    await _socketSub?.cancel();
    await _socket?.sink.close();
    return super.close();
  }

  List<twitch.Badge> getBadgesForTwitchUserId(int? twitchUserId) {
    if (twitchUserId == null) return const [];
    return state.badgesByTwitchUserId[twitchUserId] ?? const [];
  }

  SevenTvPaint? getPaintForTwitchUserId(int? twitchUserId) {
    if (twitchUserId == null) return null;
    return state.paintsByTwitchUserId[twitchUserId];
  }

  void _ensureConnected() {
    if (_socket != null) return;
    _connectedOnce = true;

    _socket = WebSocketChannel.connect(Uri.parse(_wsUrl));
    _socketSub = _socket!.stream.listen(
      (event) => _handleMessage(event),
      onDone: _reconnect,
      onError: (_) => _reconnect(),
    );

    for (final channelId in state.subscribedChannelIds) {
      _subscribeChannel(channelId);
    }
  }

  void _reconnect() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;

    _socketSub?.cancel();
    _socketSub = null;

    _socket?.sink.close();
    _socket = null;

    if (!_connectedOnce) return;
    Future.delayed(const Duration(seconds: 1), _ensureConnected);
  }

  void _send(int op, Map<String, dynamic> data) {
    final socket = _socket;
    if (socket == null) return;
    final payload = {
      'op': op,
      't': DateTime.now().millisecondsSinceEpoch,
      'd': data
    };
    final encoded = jsonEncode(payload);
    socket.sink.add(encoded);
  }

  void _subscribeChannel(int channelId) {
    final condition = {
      'id': channelId.toString(),
      'ctx': 'channel',
      'platform': 'TWITCH'
    };
    _send(35, {'type': 'cosmetic.*', 'condition': condition});
    _send(35, {'type': 'entitlement.*', 'condition': condition});
  }

  void _startHeartbeatChecker() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_expectedHeartbeatInterval <= 0) return;
      if (_lastHeartbeat <= 0) return;
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - _lastHeartbeat > _expectedHeartbeatInterval) {
        _heartbeatFailedCount += 1;
      }
      if (_heartbeatFailedCount >= 3) {
        _reconnect();
      }
    });
  }

  void _handleMessage(dynamic data) {
    if (data == null) return;

    final Map<String, dynamic> message;
    try {
      message = jsonDecode(data.toString()) as Map<String, dynamic>;
    } catch (_) {
      return;
    }

    final op = message['op'];
    if (op is! int) return;

    switch (op) {
      case 1:
        final d = message['d'];
        if (d is Map<String, dynamic>) {
          _expectedHeartbeatInterval = (d['heartbeat_interval'] as int?) ?? 0;
          _lastHeartbeat = DateTime.now().millisecondsSinceEpoch;
          _heartbeatFailedCount = 0;
          _startHeartbeatChecker();
        }
        break;
      case 2:
        _lastHeartbeat = DateTime.now().millisecondsSinceEpoch;
        _heartbeatFailedCount = 0;
        break;
      case 0:
        final d = message['d'];
        if (d is Map<String, dynamic>) {
          _handleDispatch(d);
        }
        break;
    }
  }

  void _handleDispatch(Map<String, dynamic> dispatch) {
    final type = dispatch['type'];
    final body = dispatch['body'];
    if (type is! String || body is! Map<String, dynamic>) return;

    if (type == 'cosmetic.create') {
      _handleCosmeticCreate(body);
    } else if (type == 'entitlement.create') {
      _handleEntitlementCreate(body);
    }
  }

  void _handleCosmeticCreate(Map<String, dynamic> body) {
    if (!_isCosmeticPayloadKind(body['kind'])) return;

    final object = body['object'];
    if (object is! Map<String, dynamic>) return;

    final data = (object['data'] is Map<String, dynamic>)
        ? object['data'] as Map<String, dynamic>
        : object;
    final cosmeticId = data['id']?.toString();
    if (cosmeticId == null) return;

    _cosmeticsById[cosmeticId] = data;

    final entitlements = _entitlementsByCosmeticId[cosmeticId];
    if (entitlements == null) return;
    for (final ent in entitlements) {
      _emitCombinedCosmetic(
          cosmeticId: cosmeticId, cosmetic: data, entitlement: ent);
    }
  }

  void _handleEntitlementCreate(Map<String, dynamic> body) {
    if (!_isCosmeticPayloadKind(body['kind'])) return;

    final object = body['object'];
    if (object is! Map<String, dynamic>) return;

    final user = object['user'];
    if (user is! Map<String, dynamic>) return;

    final cosmeticId = object['ref_id']?.toString();
    if (cosmeticId == null) return;

    final entitlement = <String, dynamic>{
      'id': cosmeticId,
      'kind': object['kind'],
      'selected': true,
      'user': user,
    };

    final list =
        _entitlementsByCosmeticId[cosmeticId] ?? <Map<String, dynamic>>[];
    list.add(entitlement);
    _entitlementsByCosmeticId[cosmeticId] = list;

    final cosmetic = _cosmeticsById[cosmeticId];
    if (cosmetic == null) return;
    _emitCombinedCosmetic(
        cosmeticId: cosmeticId, cosmetic: cosmetic, entitlement: entitlement);
  }

  void _emitCombinedCosmetic({
    required String cosmeticId,
    required Map<String, dynamic> cosmetic,
    required Map<String, dynamic> entitlement,
  }) {
    final user = entitlement['user'];
    if (user is! Map<String, dynamic>) return;

    final twitchUserId = _extractTwitchUserId(user);
    if (twitchUserId == null) return;

    final key = '$twitchUserId:$cosmeticId';
    if (_emittedUserCosmeticKeys.contains(key)) return;
    _emittedUserCosmeticKeys.add(key);

    final kind = _extractCosmeticKind(cosmetic, entitlement);
    if (kind == null) return;

    if (kind == 'BADGE') {
      final badge =
          _badgeFromCosmetic(cosmeticId: cosmeticId, cosmetic: cosmetic);
      if (badge == null) return;

      final nextBadges =
          Map<int, List<twitch.Badge>>.from(state.badgesByTwitchUserId);
      final existing = nextBadges[twitchUserId] ?? <twitch.Badge>[];
      nextBadges[twitchUserId] = [...existing, badge];

      emit(
        SevenTvCosmeticsState(
          badgesByTwitchUserId: nextBadges,
          paintsByTwitchUserId: state.paintsByTwitchUserId,
          subscribedChannelIds: state.subscribedChannelIds,
        ),
      );
      return;
    }

    if (kind == 'PAINT') {
      final paint = _paintFromCosmetic(cosmetic: cosmetic);
      if (paint == null) return;

      emit(
        SevenTvCosmeticsState(
          badgesByTwitchUserId: state.badgesByTwitchUserId,
          paintsByTwitchUserId: {
            ...state.paintsByTwitchUserId,
            twitchUserId: paint
          },
          subscribedChannelIds: state.subscribedChannelIds,
        ),
      );
    }
  }

  bool _isCosmeticPayloadKind(dynamic kind) {
    if (kind == 10) return true;
    if (kind is String)
      return kind.toUpperCase() == '10' || kind.toUpperCase() == 'COSMETIC';
    return kind?.toString() == '10';
  }

  int? _extractTwitchUserId(Map<String, dynamic> user) {
    final connections = user['connections'];
    if (connections is List) {
      for (final conn in connections) {
        if (conn is! Map) continue;
        if (conn['platform']?.toString().toUpperCase() != 'TWITCH') continue;
        final id = int.tryParse(conn['id']?.toString() ?? '');
        if (id != null) return id;
      }
    }

    final platform = user['platform']?.toString().toUpperCase();
    final id = int.tryParse(user['id']?.toString() ?? '');
    if (platform == 'TWITCH' && id != null) return id;

    for (final key in const ['platform_id', 'twitch_id']) {
      final parsed = int.tryParse(user[key]?.toString() ?? '');
      if (parsed != null) return parsed;
    }

    return null;
  }

  String? _extractCosmeticKind(
      Map<String, dynamic> cosmetic, Map<String, dynamic> entitlement) {
    final kind = cosmetic['kind'] ?? entitlement['kind'];
    return kind?.toString().toUpperCase();
  }

  twitch.Badge? _badgeFromCosmetic({
    required String cosmeticId,
    required Map<String, dynamic> cosmetic,
  }) {
    final host = cosmetic['host'];
    if (host is! Map<String, dynamic>) return null;

    final mipmap = _selectBestImages(host);
    if (mipmap.isEmpty) return null;

    final title = cosmetic['name']?.toString() ?? '7TV Badge';

    return twitch.Badge(
      tag: '7tv/$cosmeticId',
      name: '7tv',
      id: cosmeticId,
      title: title,
      description: null,
      mipmap: mipmap,
      cache: true,
    );
  }

  SevenTvPaint? _paintFromCosmetic({required Map<String, dynamic> cosmetic}) {
    final function = cosmetic['function']?.toString();
    if (function == null) return null;

    final repeat = cosmetic['repeat'] == true;
    final angle = (cosmetic['angle'] is num)
        ? (cosmetic['angle'] as num).toDouble()
        : null;
    final shape = cosmetic['shape']?.toString();
    final imageUrl =
        (cosmetic['image_url'] ?? cosmetic['imageUrl'] ?? cosmetic['image'])
            ?.toString();
    final stops = _parsePaintStops(cosmetic['stops']);
    final dropShadows =
        _parseDropShadows(cosmetic['shadows'] ?? cosmetic['drop_shadows']);

    return SevenTvPaint(
      function: function.toUpperCase(),
      repeat: repeat,
      angle: angle,
      shape: shape,
      imageUrl: imageUrl,
      stops: stops,
      dropShadows: dropShadows,
    );
  }

  List<SevenTvPaintStop> _parsePaintStops(dynamic rawStops) {
    if (rawStops == null) return const [];
    if (rawStops is! List) return const [];

    final stops = <SevenTvPaintStop>[];
    for (final stop in rawStops) {
      if (stop is! Map) continue;
      final color =
          _parseSevenTvColor(stop['color']) ?? const Color(0xFFFFFFFF);
      final at = stop['at'] ?? stop['position'] ?? 0;
      final position =
          (at is num) ? at.toDouble() : double.tryParse(at.toString()) ?? 0.0;
      stops.add(
          SevenTvPaintStop(color: color, position: position.clamp(0.0, 1.0)));
    }
    stops.sort((a, b) => a.position.compareTo(b.position));
    return stops;
  }

  List<SevenTvDropShadow> _parseDropShadows(dynamic rawShadows) {
    if (rawShadows == null) return const [];
    if (rawShadows is! List) return const [];

    final shadows = <SevenTvDropShadow>[];
    for (final shadow in rawShadows) {
      if (shadow is! Map) continue;

      final xOffset =
          _parseDouble(shadow['x_offset'] ?? shadow['xOffset']) ?? 0.0;
      final yOffset =
          _parseDouble(shadow['y_offset'] ?? shadow['yOffset']) ?? 0.0;
      final radius = _parseDouble(shadow['radius']) ?? 0.0;
      final color =
          _parseSevenTvColor(shadow['color']) ?? const Color(0xFF000000);

      if (radius > 0) {
        shadows.add(SevenTvDropShadow(
          xOffset: xOffset,
          yOffset: yOffset,
          radius: radius,
          color: color,
        ));
      }
    }
    return shadows;
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Color? _parseSevenTvColor(dynamic raw) {
    if (raw is int) {
      final r = (raw >> 24) & 0xFF;
      final g = (raw >> 16) & 0xFF;
      final b = (raw >> 8) & 0xFF;
      final a = raw & 0xFF;
      return Color.fromARGB(a, r, g, b);
    }

    final s = raw?.toString();
    if (s == null || !s.startsWith('#')) return null;

    final hex = s.substring(1);
    if (hex.length == 6) return Color(int.parse('FF$hex', radix: 16));
    if (hex.length == 8) {
      final rrggbb = hex.substring(0, 6);
      final aa = hex.substring(6, 8);
      return Color(int.parse('$aa$rrggbb', radix: 16));
    }

    return null;
  }

  List<String?> _selectBestImages(Map<String, dynamic> host) {
    final files = host['files'];
    final rawUrl = host['url']?.toString();
    if (files is! List || rawUrl == null) return const [];

    final base = rawUrl.startsWith('http') ? rawUrl : 'https:$rawUrl';

    String? findByName(String name) {
      for (final f in files) {
        if (f is! Map) continue;
        if (f['name']?.toString() == name) return '$base/$name';
      }
      return null;
    }

    final order = const ['1x.webp', '2x.webp', '3x.webp', '4x.webp'];
    final urls = <String?>[];

    for (final name in order) {
      final url = findByName(name);
      if (url != null) urls.add(url);
    }

    if (urls.isNotEmpty) return urls;

    for (final f in files) {
      if (f is! Map) continue;
      final name = f['name']?.toString();
      final format = f['format']?.toString().toUpperCase();
      if (name == null) continue;
      if (format == 'WEBP' || name.toLowerCase().endsWith('.webp')) {
        urls.add('$base/$name');
      }
    }

    return urls;
  }
}
