import 'package:chat_gpt/feature/widgets/drop_down.dart';
import 'package:flutter/material.dart';

import '../data/constants.dart';
import '../feature/widgets/text_widget.dart';

class ShowModal {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: kScaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: TextWidget(
                  label: 'Chosen Model: ',
                  fontSize: 16,
                ),
              ),
              Flexible(flex: 2, child: ModelDropDownWidget2()),
            ],
          ),
        );
      },
    );
  }
}
