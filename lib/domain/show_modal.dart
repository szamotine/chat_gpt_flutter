import 'package:chat_gpt/domain/providers/models_provider.dart';
import 'package:chat_gpt/feature/widgets/models_drop_down.dart';
import 'package:flutter/material.dart';

import '../data/constants.dart';
import '../feature/widgets/text_widget.dart';

class ShowModal {
  static Future<void> showModalSheet({required BuildContext context, required ModelsProvider provider}) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: kScaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: TextWidget(
                  label: 'Chosen Model: ',
                  fontSize: 16,
                ),
              ),
              Flexible(
                flex: 2,
                child: ModelDropDownWidget(
                  modelsProvider: provider,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
