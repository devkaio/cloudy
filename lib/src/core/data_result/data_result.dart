sealed class DataResult<S, F> {
  const DataResult._internal();

  factory DataResult.success(S data) = _Success;

  factory DataResult.failure(F failure) = _Failure;

  bool get isSuccess => this is _Success<S, F>;

  bool get isFailure => this is _Failure<S, F>;

  S? get data => fold<S?>(
        (data) => data,
        (failure) => null,
      );

  F? get failure => fold<F?>(
        (data) => null,
        (failure) => failure,
      );

  R fold<R>(
    R Function(S data) onSuccess,
    R Function(F failure) onFailure,
  );
}

class _Success<S, F> extends DataResult<S, F> {
  _Success(this._value) : super._internal();

  final S _value;

  @override
  R fold<R>(
    R Function(S data) onSuccess,
    R Function(F failure) onFailure,
  ) =>
      onSuccess(_value);
}

class _Failure<S, F> extends DataResult<S, F> {
  _Failure(this._value) : super._internal();

  final F _value;

  @override
  R fold<R>(
    R Function(S data) onSuccess,
    R Function(F failure) onFailure,
  ) =>
      onFailure(_value);
}
