// ignore_for_file: avoid_print

enum HTTPMethods { post, get, put, delete }

class APIService {
  APIService._singleton();

  static final APIService instance = APIService._singleton();
}
