import 'dart:convert';

import 'package:http/http.dart';

class ServerException implements Exception {
  final String message;
  const ServerException({required this.message});
}

class NoInternatException extends ServerException {
  const NoInternatException()
    : super(
        message:
            'No Internet Connection. Please check your connection and try again',
      );
}

class ConnectTimeoutException extends ServerException {
  const ConnectTimeoutException()
    : super(message: 'Connection timeout. Please try again');
}

class ForbiddenException extends ServerException {
  const ForbiddenException({required super.message});
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException({required super.message});
}

class CacheException extends ServerException {
  const CacheException({required super.message});
}

class BadRequestException extends ServerException {
  const BadRequestException({required super.message});
}

class NotFoundException extends ServerException {
  const NotFoundException({required super.message});
}

class UnknownException extends ServerException {
  const UnknownException({required super.message});
}

class InternalServerException extends ServerException {
  const InternalServerException({required super.message});
}

dynamic errorHandling(Response response) {
  Map<String, dynamic> jsonData = response.body.isNotEmpty
      ? jsonDecode(response.body)
      : <String, dynamic>{};
  switch (response.statusCode) {
    case 200 || 201:
      return jsonData;
    case 400:
      throw BadRequestException(
        message:
            jsonData['message'] ??
            'Bad request. Please check your input and try again.',
      );
    case 401:
      throw UnauthorizedException(
        message:
            jsonData['message'] ??
            'Unauthenticated. Please check your credentials and try again',
      );
    case 403:
      throw ForbiddenException(
        message:
            jsonData['message'] ?? 'You do not have access to this resource.',
      );
    case 404:
      throw NotFoundException(
        message: jsonData['message'] ?? ' Resource not found',
      );
    case 500:
      throw InternalServerException(
        message:
            jsonData['message'] ??
            'Internal Server Error. Please try again later.',
      );
    default:
      throw UnknownException(
        message:
            jsonData['message'] ?? 'Something went wrong. Please try again',
      );
  }
}
