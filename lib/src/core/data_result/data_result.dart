/// This follows the Railway Oriented Programming (ROP) pattern.
///
/// The `DataResult` class represents the result of an operation that can either be a success or a failure.
///
/// If the operation is successful, the `DataResult` will contain the data of type `S`. Otherwise, it will contain the failure of type `F`.
///
/// For example:
///
/// ```dart
/// final result = DataResult.success(42);
///
/// result.fold(
///  (data) => print('Data: $data'), // prints 'Data: 42'
///  (failure) => print('Failure: $failure'),
/// );
/// ```
sealed class DataResult<S, F> {
  const DataResult._internal();

  /// Creates a success result with the given data.
  factory DataResult.success(S data) = SuccessData;

  /// Creates a failure result with the given failure.
  factory DataResult.failure(F failure) = FailureData;

  /// Returns `true` if the operation was successful.
  bool get isSuccess => this is SuccessData<S, F>;

  /// Returns `true` if the operation was not successful.
  bool get isFailure => this is FailureData<S, F>;

  /// Returns the data if the operation was successful.
  S? get data => fold<S?>(
        (data) => data,
        (failure) => null,
      );

  /// Returns the failure if the operation was not successful.
  F? get failure => fold<F?>(
        (data) => null,
        (failure) => failure,
      );

  /// Returns the result of the operation based on whether it was successful or not.
  R fold<R>(
    R Function(S data) onSuccess,
    R Function(F failure) onFailure,
  );
}

final class SuccessData<S, F> extends DataResult<S, F> {
  SuccessData(this.value) : super._internal();

  final S value;

  @override
  R fold<R>(
    R Function(S data) onSuccess,
    R Function(F failure) onFailure,
  ) =>
      onSuccess(value);
}

final class FailureData<S, F> extends DataResult<S, F> {
  FailureData(this.value) : super._internal();

  final F value;

  @override
  R fold<R>(
    R Function(S data) onSuccess,
    R Function(F failure) onFailure,
  ) =>
      onFailure(value);
}
