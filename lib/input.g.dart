// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$parseRuleHash() => r'0ef7de4a36b96c9237880f48d67d5bb1756d812b';

/// See also [parseRule].
@ProviderFor(parseRule)
final parseRuleProvider = AutoDisposeProvider<Result<Rule>>.internal(
  parseRule,
  name: r'parseRuleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$parseRuleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ParseRuleRef = AutoDisposeProviderRef<Result<Rule>>;
String _$ruleStrHash() => r'9afcdcd22a2201c0a69a5035c81c15a4e1a4945f';

/// See also [RuleStr].
@ProviderFor(RuleStr)
final ruleStrProvider = NotifierProvider<RuleStr, String>.internal(
  RuleStr.new,
  name: r'ruleStrProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$ruleStrHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RuleStr = Notifier<String>;
String _$changeModeHash() => r'e1a7a92a02693169edc84f1b80a0a458ef46c4b4';

/// See also [ChangeMode].
@ProviderFor(ChangeMode)
final changeModeProvider =
    NotifierProvider<ChangeMode, ChangeModeEnum>.internal(
  ChangeMode.new,
  name: r'changeModeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$changeModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChangeMode = Notifier<ChangeModeEnum>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
