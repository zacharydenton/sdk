// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
part of dart._runtime;

bool _trapRuntimeErrors = true;
bool _ignoreWhitelistedErrors = true;
bool _failForWeakModeIsChecks = true;

// Override, e.g., for testing
void trapRuntimeErrors(bool flag) {
  _trapRuntimeErrors = flag;
}

void ignoreWhitelistedErrors(bool flag) {
  _ignoreWhitelistedErrors = flag;
}

/// Throw an exception on `is` checks that would return an unsound answer in
/// non-strong mode Dart.
///
/// For example `x is List<int>` where `x = <Object>['hello']`.
///
/// These checks behave correctly in strong mode (they return false), however,
/// they will produce a different answer if run on a platform without strong
/// mode. As a debugging feature, these checks can be configured to throw, to
/// avoid seeing different behavior between modes.
///
/// (There are many other ways that different `is` behavior can be observed,
/// however, even with this flag. The most obvious is due to lack of reified
/// generic type parameters. This affects generic functions and methods, as
/// well as generic types when the type parameter was inferred. Setting this
/// flag to `true` will not catch these differences in behavior..)
void failForWeakModeIsChecks(bool flag) {
  _failForWeakModeIsChecks = flag;
}

throwCastError(object, actual, type) => JS(
    '',
    '''(() => {
  var found = $typeName($actual);
  var expected = $typeName($type);
  if ($_trapRuntimeErrors) debugger;
  $throw_(new $CastErrorImplementation($object, found, expected));
})()''');

throwTypeError(object, actual, type) => JS(
    '',
    '''(() => {
  var found = $typeName($actual);
  var expected = $typeName($type);
  if ($_trapRuntimeErrors) debugger;
  $throw_(new $TypeErrorImplementation($object, found, expected));
})()''');

throwStrongModeCastError(object, actual, type) => JS(
    '',
    '''(() => {
  var found = $typeName($actual);
  var expected = $typeName($type);
  if ($_trapRuntimeErrors) debugger;
  $throw_(new $StrongModeCastError($object, found, expected));
})()''');

throwStrongModeTypeError(object, actual, type) => JS(
    '',
    '''(() => {
  var found = $typeName($actual);
  var expected = $typeName($type);
  if ($_trapRuntimeErrors) debugger;
  $throw_(new $StrongModeTypeError($object, found, expected));
})()''');

throwUnimplementedError(message) => JS(
    '',
    '''(() => {
  if ($_trapRuntimeErrors) debugger;
  $throw_(new $UnimplementedError($message));
})()''');

throwAssertionError([message]) => JS(
    '',
    '''(() => {
  if ($_trapRuntimeErrors) debugger;
  let error = $message != null
        ? new $AssertionErrorWithMessage($message())
        : new $AssertionError();
  $throw_(error);
})()''');

throwCyclicInitializationError([String message]) {
  if (_trapRuntimeErrors) JS('', 'debugger');
  throw new CyclicInitializationError(message);
}

throwNullValueError() => JS(
    '',
    '''(() => {
  // TODO(vsm): Per spec, we should throw an NSM here.  Technically, we ought
  // to thread through method info, but that uglifies the code and can't
  // actually be queried ... it only affects how the error is printed.
  if ($_trapRuntimeErrors) debugger;
  $throw_(new $NoSuchMethodError(null,
      new $Symbol('<Unexpected Null Value>'), null, null, null));
})()''');

throwNoSuchMethodError(
        receiver, memberName, positionalArguments, namedArguments) =>
    JS(
        '',
        '''(() => {
  if ($_trapRuntimeErrors) debugger;
  $throw_(new $NoSuchMethodError($receiver, $memberName, $positionalArguments, $namedArguments));
})()''');
