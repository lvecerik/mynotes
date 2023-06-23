//login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthExcetion implements Exception {}

//register exceptions
class WeakPasswordAuthExcetion implements Exception {}

class EmailAlreadyInUsedAuthExcetion implements Exception {}

class InvalidEmailAuthExcetion implements Exception {}

//generic exceptions

class GenericAuthExcetion implements Exception {}

class UserNotLoggedInAuthExceptions implements Exception {}
