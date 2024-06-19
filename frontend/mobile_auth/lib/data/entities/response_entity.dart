interface class IResponseEntity {
  late final bool success;
  late final dynamic data;
  late final String? message;
}

class ResponseEntity implements IResponseEntity {
  @override
  var data;
  @override
  String? message;
  @override
  bool success;

  ResponseEntity({
    required this.success,
    this.data,
    this.message,
  });
}
