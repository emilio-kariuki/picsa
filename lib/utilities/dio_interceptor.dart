import 'package:dio/dio.dart';
import 'package:picsa/utilities/supabase_config.dart';

class DioInterceptor extends Interceptor {
  
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final user = supabase.auth.currentUser;
    options.headers['user'] = user!.id;
    options.headers['Content-Type'] = 'application/json';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler,) {
    if(err.response?.statusCode == 401){

    }
    super.onError(err, handler);
  }
}
