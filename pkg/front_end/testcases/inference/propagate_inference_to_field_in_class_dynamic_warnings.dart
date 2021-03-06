// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/*@testedFeatures=inference*/
library test;

class A {
  int x = 2;
}

test() {
  dynamic a = new A();
  A b = /*info:DYNAMIC_CAST*/ /*@promotedType=none*/ a;
  print(/*info:DYNAMIC_INVOKE*/ /*@promotedType=none*/ a.x);
  print(
      /*info:DYNAMIC_INVOKE*/ (/*info:DYNAMIC_INVOKE*/ /*@promotedType=none*/ a
              .x) +
          2);
}
