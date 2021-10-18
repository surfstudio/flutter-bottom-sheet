// Copyright (c) 2019-present,  SurfStudio LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final delegate = FlexibleBottomSheetHeaderDelegate(
    maxHeight: 1,
    minHeight: 0.2,
    child: Container(),
  );

  final anotherDelegate = FlexibleBottomSheetHeaderDelegate(
    maxHeight: 0.8,
    child: Container(),
  );

  final context = Context();

  test('The methods FlexibleBottomSheetHeaderDelegate work correctly', () {
    final child = delegate.build(
      context,
      0.6,
      true,
    );

    expect(delegate.maxExtent, same(delegate.maxHeight));
    expect(delegate.minExtent, same(delegate.minHeight));
    expect(child, same(delegate.child));
    expect(delegate.shouldRebuild(anotherDelegate), isTrue);
  });
}

class Context extends Fake implements BuildContext {}
