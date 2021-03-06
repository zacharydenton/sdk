// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/*@testedFeatures=inference*/
library test;

class C<T extends num> {
  T a;

  void op(int b) {
    T r1 = a + /*@promotedType=none*/ b;
    T r2 = a - /*@promotedType=none*/ b;
    T r3 = a * /*@promotedType=none*/ b;
  }

  void opEq(int b) {
    a += /*@promotedType=none*/ b;
    a -= /*@promotedType=none*/ b;
    a *= /*@promotedType=none*/ b;
  }
}

main() {}
