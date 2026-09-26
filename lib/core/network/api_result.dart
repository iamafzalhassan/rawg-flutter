sealed class ApiResult<T> {
  const ApiResult();
}

class ApiFailure<T> extends ApiResult<T> {
  final String message;

  const ApiFailure(this.message);
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;

  const ApiSuccess(this.data);
}
