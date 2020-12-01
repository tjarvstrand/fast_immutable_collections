import "dart:collection";

import "package:meta/meta.dart";

import "../base/immutable_collection.dart";
import "imap.dart";
import "imap_extension.dart";

/// The [UnmodifiableMapView] is a relatively safe, unmodifiable [Map] that is built from an
/// [IMap] or another [Map]. The construction of the [UnmodifiableMapView] is very fast,
/// since it makes no copies of the given map items, but just uses it directly.
///
/// If you try to use methods that modify the [UnmodifiableMapView], like [add],
/// it will throw an [UnsupportedError].
///
/// If you create it from an [IMap], it is also very fast to lock the [UnmodifiableMapView]
/// back into an [IMap].
///
/// <br>
///
/// ## How does it compare to [Map.unmodifiable]?
///
/// [Map.unmodifiable] is slow, but it's always safe, because *it is not a view*, and
/// actually creates a new map. On the other hand, [UnmodifiableMapView] is fast, but if
/// you create it from a regular [Map] and then modify that original [Map], you will also
/// be modifying the view. Also note, if you create an [UnmodifiableMapView] from an [IMap],
/// then it's totally safe because the original [IMap] can't be modified &mdash; unless of course,
/// again, you've created it from a [IMap.unsafe] constructor.
///
/// See also: [ModifiableMapView]
@immutable
class UnmodifiableMapView<K, V> with MapMixin<K, V> implements Map<K, V>, CanBeEmpty {
  final IMap<K, V> _iMap;
  final Map<K, V> _map;

  UnmodifiableMapView(IMap<K, V> imap)
      : _iMap = imap ?? IMap.empty<K, V>(),
        _map = null;

  UnmodifiableMapView.fromMap(Map<K, V> map)
      : _iMap = null,
        _map = map;

  @override
  void operator []=(K key, V value) => throw UnsupportedError("Map is unmodifiable.");

  @override
  V operator [](Object key) => _iMap != null ? _iMap[key as K] : _map[key];

  @override
  void clear() => throw UnsupportedError("Map is unmodifiable.");

  @override
  V remove(Object key) => throw UnsupportedError("Map is unmodifiable.");

  @override
  Iterable<K> get keys => _iMap?.keys ?? _map.keys;

  IMap<K, V> get lock => _iMap ?? _map.lock;
}
