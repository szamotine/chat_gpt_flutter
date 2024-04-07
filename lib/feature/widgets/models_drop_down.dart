import 'package:chat_gpt/data/constants.dart';
import 'package:chat_gpt/domain/providers/models_provider.dart';
import 'package:chat_gpt/feature/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModelDropDownWidget extends StatefulWidget {
  const ModelDropDownWidget({super.key});

  @override
  State<ModelDropDownWidget> createState() => _ModelDropDownWidgetState();
}

class _ModelDropDownWidgetState extends State<ModelDropDownWidget> {
  String currentModel = "Model1";

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      dropdownColor: kScaffoldBackgroundColor,
      items: modelsItem,
      value: currentModel,
      onChanged: (value) {
        setState(() {
          currentModel = value.toString();
        });
      },
    );
  }
}

class ModelDropDownWidget2 extends StatefulWidget {
  const ModelDropDownWidget2({super.key});

  @override
  State<ModelDropDownWidget2> createState() => _ModelDropDownWidget2State();
}

class _ModelDropDownWidget2State extends State<ModelDropDownWidget2> {
  String? currentModel; // = "gpt-3.5-turbo";

  @override
  Widget build(BuildContext context) {
    final ModelsProvider modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    currentModel = modelsProvider.getCurrentModel;

    return FutureBuilder(
      future: modelsProvider.getAllModels(), //OpenAiAPI.getModels(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: TextWidget(
              label: snapshot.error.toString(),
            ),
          );
        }
        return snapshot.data == null || snapshot.data!.isEmpty
            ? const SizedBox.shrink()
            : DropdownButton(
                dropdownColor: kScaffoldBackgroundColor,
                items: List<DropdownMenuItem<String>>.generate(
                  snapshot.data!.length,
                  (index) => DropdownMenuItem(
                    value: snapshot.data![index],
                    child: TextWidget(
                      label: snapshot.data![index],
                      fontSize: 15,
                    ),
                  ),
                ),
                value: currentModel,
                onChanged: (value) {
                  setState(
                    () {
                      modelsProvider.setCurrentModel(value.toString());
                    },
                  );
                },
              );
      },
    );
  }
}
