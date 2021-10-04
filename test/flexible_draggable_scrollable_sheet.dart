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

import 'test_utils.dart';

void main() {
  testWidgets(
    'FlexibleDraggableScrollableSheet builds normally',
    (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          FlexibleDraggableScrollableSheet(
            builder: (context, scrollController) {
              return ListView.builder(
                controller: scrollController,
                itemCount: 25,
                itemBuilder: (context, index) {
                  return ListTile(title: Text('Item $index'));
                },
              );
            },
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    },
  );
}
