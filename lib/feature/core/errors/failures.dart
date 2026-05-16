abstract class Failure {
  final String message;
  const Failure(this.message);
}

// أخطاء السيرفر (فايربيز مثلاً)
class ServerFailure extends Failure {
  // هنا بنبعت الـ message للكلاس الأب (super) مباشرة
  const ServerFailure({required String message}) : super(message);
}

// أخطاء الكاش (لو الداتا مش موجودة في الموبايل)
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
