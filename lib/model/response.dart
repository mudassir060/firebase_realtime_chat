class ResponseModel<T> {
  final Status status;
  final T? data;
  final String? message;

  ResponseModel.completed(this.data)
      : status = Status.success,
        message = null;
  ResponseModel.error(this.message, {this.data}) : status = Status.error;
  ResponseModel.loading()
      : status = Status.loading,
        data = null,
        message = null;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status {
  success,
  error,
  loading,
}
