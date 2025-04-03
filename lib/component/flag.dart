import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyapp/bloc/flag_bloc.dart';
import 'package:storyapp/enum/lang.dart';

class FlagIconWidget extends StatelessWidget {
  const FlagIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        icon: const Icon(Icons.flag),
        items:
            Language.values.map((Language lang) {
              final flag = lang.flag;
              return DropdownMenuItem(
                value: lang,
                child: Center(
                  child: Text(
                    flag,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                onTap: () {
                  context.read<FlagBloc>().add(ChangeLanguageEvent(lang));
                },
              );
            }).toList(),
        onChanged: (Language? newValue) {
          // Handle change
        },
      ),
    );
  }
}
