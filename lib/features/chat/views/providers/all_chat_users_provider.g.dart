// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_chat_users_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AllChatUsers)
final allChatUsersProvider = AllChatUsersProvider._();

final class AllChatUsersProvider
    extends $NotifierProvider<AllChatUsers, AsyncValue<dynamic>> {
  AllChatUsersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allChatUsersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allChatUsersHash();

  @$internal
  @override
  AllChatUsers create() => AllChatUsers();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<dynamic>>(value),
    );
  }
}

String _$allChatUsersHash() => r'819aee9584ceffa99d04aa41ed023f3d2265d438';

abstract class _$AllChatUsers extends $Notifier<AsyncValue<dynamic>> {
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
