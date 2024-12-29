sealed class Result<T> {
  bool get isSuccess => this is Success<T>;
  T? get data {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    return null;
  }
  String? get message {
    if (this is Failure<T>) {
      return (this as Failure<T>).message;
    }
    return null;
  }
}

class Success<T> extends Result<T> {
  @override
  final T data;

  Success(this.data);
}

class Failure<T> extends Result<T> {
  @override
  final String message;

  Failure(this.message);
}