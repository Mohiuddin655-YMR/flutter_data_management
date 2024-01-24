part of 'core.dart';

///
/// You can use base class [Data] without [Entity]
///
class DataResponse<T extends Entity> extends Response<T> {
  DataResponse({
    super.requestCode,
    super.available,
    super.cancel,
    super.complete,
    super.error,
    super.failed,
    super.internetError,
    super.loading,
    super.nullable,
    super.paused,
    super.stopped,
    super.successful,
    super.timeout,
    super.valid,
    super.data,
    super.backups,
    super.ignores,
    super.result,
    super.progress,
    super.status,
    super.exception,
    super.message,
    super.feedback,
    super.snapshot,
  });

  @override
  DataResponse<T> copy({
    int? requestCode,
    bool? available,
    bool? cancel,
    bool? complete,
    bool? error,
    bool? failed,
    bool? internetError,
    bool? loading,
    bool? nullable,
    bool? paused,
    bool? stopped,
    bool? successful,
    bool? timeout,
    bool? valid,
    T? data,
    List<T>? backups,
    List<T>? ignores,
    List<T>? result,
    double? progress,
    Status? status,
    String? exception,
    String? message,
    dynamic feedback,
    dynamic snapshot,
  }) {
    return DataResponse<T>(
      available: available,
      cancel: cancel,
      complete: complete,
      data: data,
      error: error,
      exception: exception,
      failed: failed,
      feedback: feedback,
      internetError: internetError,
      loading: loading ?? false,
      message: message,
      nullable: nullable,
      paused: paused,
      progress: progress ?? this.progress,
      requestCode: requestCode ?? this.requestCode,
      backups: backups,
      ignores: ignores,
      result: result,
      snapshot: snapshot,
      status: status,
      stopped: stopped,
      successful: successful,
      timeout: timeout,
      valid: valid,
    );
  }

  @override
  DataResponse<T> from(Response<T> response) {
    return copy(
      available: response.isAvailable,
      cancel: response.isCancel,
      complete: response.isComplete,
      data: response.data,
      error: response.isError,
      exception: response.exception,
      failed: response.isFailed,
      feedback: response.feedback,
      internetError: response.isInternetError,
      loading: response.isLoading,
      message: response.message,
      nullable: response.isNullable,
      paused: response.isPaused,
      progress: response.progress,
      requestCode: response.requestCode,
      backups: response.backups,
      ignores: response.ignores,
      result: response.result,
      snapshot: response.snapshot,
      status: response.status,
      stopped: response.isStopped,
      successful: response.isSuccessful,
      timeout: response.isTimeout,
      valid: response.isValid,
    );
  }

  @override
  DataResponse<T> modify({
    bool? available,
    bool? cancel,
    bool? complete,
    bool? error,
    bool? failed,
    bool? internetError,
    bool? loading,
    bool? nullable,
    bool? paused,
    bool? stopped,
    bool? successful,
    bool? timeout,
    bool? valid,
    T? data,
    List<T>? backups,
    List<T>? ignores,
    List<T>? result,
    double? progress,
    Status? status,
    String? exception,
    String? message,
    dynamic feedback,
    dynamic snapshot,
  }) {
    super.modify(
      available: available,
      cancel: cancel,
      complete: complete,
      error: error,
      failed: failed,
      internetError: internetError,
      loading: loading,
      nullable: nullable,
      paused: paused,
      stopped: stopped,
      successful: successful,
      timeout: timeout,
      valid: valid,
      data: data,
      backups: backups,
      ignores: ignores,
      result: result,
      progress: progress,
      status: status,
      exception: exception,
      message: message,
      feedback: feedback,
      snapshot: snapshot,
    );
    return this;
  }

  @override
  DataResponse<T> withAvailable(
    bool available, {
    T? data,
    Status? status,
    String? message,
  }) {
    super.withAvailable(
      available,
      data: data,
      status: status,
      message: message,
    );
    return this;
  }

  @override
  DataResponse<T> withCancel(bool cancel, {String? message}) {
    super.withCancel(cancel, message: message);
    return this;
  }

  @override
  DataResponse<T> withComplete(bool complete, {String? message}) {
    super.withComplete(complete, message: message);
    return this;
  }

  @override
  DataResponse<T> withData(T? data, {String? message, Status? status}) {
    super.withData(data, message: message, status: status);
    return this;
  }

  @override
  DataResponse<T> withException(dynamic exception, {Status? status}) {
    super.withException(exception, status: status);
    return this;
  }

  @override
  DataResponse<T> withFailed(bool failed) {
    super.withFailed(failed);
    return this;
  }

  @override
  DataResponse<T> withFeedback(
    dynamic feedback, {
    String? message,
    String? exception,
    Status status = Status.ok,
    bool loaded = true,
  }) {
    super.withFeedback(
      feedback,
      message: message,
      exception: exception,
      status: status,
      loaded: loaded,
    );
    return this;
  }

  @override
  DataResponse<T> withBackup(
    T? value, {
    dynamic feedback,
    String? message,
    Status? status,
  }) {
    super.withBackup(
      value,
      feedback: feedback,
      message: message,
      status: status,
    );
    return this;
  }

  @override
  DataResponse<T> withBackups(
    List<T>? value, {
    dynamic feedback,
    String? message,
    Status? status,
  }) {
    super.withBackups(
      value,
      feedback: feedback,
      message: message,
      status: status,
    );
    return this;
  }

  @override
  DataResponse<T> withIgnore(T? value, {String? message, Status? status}) {
    super.withIgnore(value, message: message, status: status);
    return this;
  }

  @override
  DataResponse<T> withInternetError(String message) {
    super.withInternetError(message);
    return this;
  }

  @override
  DataResponse<T> withLoaded(bool loaded) {
    super.withLoaded(loaded);
    return this;
  }

  @override
  DataResponse<T> withMessage(String? message, {Status status = Status.ok}) {
    super.withMessage(message, status: status);
    return this;
  }

  @override
  DataResponse<T> withNullable(bool nullable) {
    super.withNullable(nullable);
    return this;
  }

  @override
  DataResponse<T> withPaused(bool paused) {
    super.withPaused(paused);
    return this;
  }

  @override
  DataResponse<T> withProgress(double progress, {String? message}) {
    super.withProgress(progress, message: message);
    return this;
  }

  @override
  DataResponse<T> withResult(
    List<T>? result, {
    String? message,
    Status? status,
  }) {
    super.withResult(result, message: message, status: status);
    return this;
  }

  @override
  DataResponse<T> withSnapshot(
    dynamic snapshot, {
    String? message,
    Status? status,
  }) {
    super.withSnapshot(snapshot, message: message, status: status);
    return this;
  }

  @override
  DataResponse<T> withStatus(Status status, {String? message}) {
    super.withStatus(status, message: message);
    return this;
  }

  @override
  DataResponse<T> withStopped(bool stopped) {
    super.withStopped(stopped);
    return this;
  }

  @override
  DataResponse<T> withSuccessful(bool successful, {String? message}) {
    super.withSuccessful(successful, message: message);
    return this;
  }

  @override
  DataResponse<T> withTimeout(bool timeout) {
    super.withTimeout(timeout);
    return this;
  }

  @override
  DataResponse<T> withValid(bool valid) {
    super.withValid(valid);
    return this;
  }
}
