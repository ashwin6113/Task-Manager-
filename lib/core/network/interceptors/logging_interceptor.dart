import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Logs every request, response, and error to the console (debug builds only).
class LoggingInterceptor extends Interceptor {
  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 100,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d(
      '➡️ REQUEST[${options.method}] => ${options.uri}\n'
      'Headers: ${options.headers}\n'
      'Data: ${options.data}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.d(
      '⬅️ RESPONSE[${response.statusCode}] => ${response.requestOptions.uri}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '❌ ERROR[${err.response?.statusCode}] => ${err.requestOptions.uri}',
      error: err,
    );
    handler.next(err);
  }
}
