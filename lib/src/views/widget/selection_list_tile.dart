import 'package:flutter/material.dart';
import 'package:survey_kit/src/constants/colors.dart';

class SelectionListTile extends StatelessWidget {
  final String text;
  final Function onTap;
  final bool isSelected;

  const SelectionListTile({
    Key? key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: ColorsTheme.mobilmellaTextWhite,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: ListTile(
              title: Text(
                text,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textTheme.headlineSmall?.color,
                    ),
              ),
              trailing: isSelected
                  ? Icon(
                      Icons.check,
                      size: 22,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : ColorsTheme.mobilmellLoginCardBg,
                    )
                  : Container(
                      width: 22,
                      height: 22,
                    ),
              onTap: () => onTap.call(),
            ),
          ),
        ],
      ),
    );
  }
}
