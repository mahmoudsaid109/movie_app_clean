import 'package:dartz/dartz.dart';
import 'package:movies_app_clean/core/errors/failure.dart';

abstract class BaseUsecase<T> {
  Future<Either<Failure, T>> call();
}
