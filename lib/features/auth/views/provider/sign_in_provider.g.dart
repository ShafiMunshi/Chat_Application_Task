// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignInProvider)
final signInProviderProvider = SignInProviderProvider._();

final class SignInProviderProvider
    extends $NotifierProvider<SignInProvider, AsyncValue<dynamic>> {
  SignInProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInProviderHash();

  @$internal
  @override
  SignInProvider create() => SignInProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<dynamic>>(value),
    );
  }
}

String _$signInProviderHash() => r'57e014e9aa90865d362f0821b4422e93e352a6bb';

abstract class _$SignInProvider extends $Notifier<AsyncValue<dynamic>> {
  AsyncValue<dynamic> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<dynamic>, AsyncValue<dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<dynamic>, AsyncValue<dynamic>>,
              AsyncValue<dynamic>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
