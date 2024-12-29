RiverpodやFreezedでは必ずジェネレーターを使用してください。

**Riverpod**
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '{file_name}.g.dart';

@riverpod
class MyClass extends _$MyClass {
    @override
    {type} build() {
        return initalValue;
    }
}
```
