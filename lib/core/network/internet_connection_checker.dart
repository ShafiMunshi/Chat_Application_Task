import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final netConnectionCheckerProvider = Provider<INetConnectionChecker>((ref) {
  return NetConnectionCheckerImpl(
    ref.watch(_internetConnectionCheckerProvider),
  );
});


abstract interface class INetConnectionChecker {
  Future<bool> get hasConnection;
}

class NetConnectionCheckerImpl implements INetConnectionChecker {
  final InternetConnectionChecker _checker;

  NetConnectionCheckerImpl(this._checker);

  @override
  Future<bool> get hasConnection async {
    final result = await _checker.hasConnection;
    return result;
  }
}

final _internetConnectionCheckerProvider = Provider<InternetConnectionChecker>((
  ref,
) {
  return InternetConnectionChecker.instance;
});
