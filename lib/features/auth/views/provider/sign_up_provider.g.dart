// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignUpProvider)
final signUpProviderProvider = SignUpProviderProvider._();

final class SignUpProviderProvider
    extends $NotifierProvider<SignUpProvider, AsyncValue<dynamic>> {
  SignUpProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signUpProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signUpProviderHash();

  @$internal
  @override
  SignUpProvider create() => SignUpProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<dynamic>>(value),
    );
  }
}

String _$signUpProviderHash() => r'010ad673a5493f7ce099cf9f209e6634a74678d4';

abstract class _$SignUpProvider extends $Notifier<AsyncValue<dynamic>> {
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
