import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:survey_kit/src/answer_format/double_answer_format.dart';
import 'package:survey_kit/src/constants/colors.dart';
import 'package:survey_kit/src/result/question/double_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/decoration/input_decoration.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

class DoubleAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final DoubleQuestionResult? result;

  const DoubleAnswerView({
    Key? key,
    required this.questionStep,
    required this.result,
  }) : super(key: key);

  @override
  _DoubleAnswerViewState createState() => _DoubleAnswerViewState();
}

class _DoubleAnswerViewState extends State<DoubleAnswerView> {
  late final DoubleAnswerFormat _doubleAnswerFormat;
  late final TextEditingController _controller;
  late final DateTime _startDate;

  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _doubleAnswerFormat = widget.questionStep.answerFormat as DoubleAnswerFormat;
    _controller = TextEditingController();
    _controller.text = widget.result?.result?.toString() ?? '';
    _checkValidation(_controller.text);
    _startDate = DateTime.now();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkValidation(String text) {
    setState(() {
      _isValid = text.isNotEmpty && double.tryParse(text.replaceAll(",", ".")) != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: widget.questionStep,
      hasMargin: true,
      resultFunction: () => DoubleQuestionResult(
        id: widget.questionStep.stepIdentifier,
        startDate: _startDate,
        endDate: DateTime.now(),
        valueIdentifier: _controller.text,
        result: double.tryParse(_controller.text) ?? _doubleAnswerFormat.defaultValue ?? null,
      ),
      isValid: _isValid || widget.questionStep.isOptional,
      title: widget.questionStep.title.isNotEmpty
          ? Text(
              widget.questionStep.title,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            )
          : widget.questionStep.content,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
          ),
          child: Container(
            color: ColorsTheme.mobilmellaTextWhite,
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width,
            child: TextField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*[.]?\d*$')),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  String sanitizedText = newValue.text.replaceAll(',', '.');
                  if (sanitizedText.isEmpty) {
                    return newValue;
                  }
                  if (sanitizedText == '.' || sanitizedText == '0.') {
                    return newValue.copyWith(text: '0.');
                  }
                  if (sanitizedText.split('.').length > 2) {
                    return oldValue;
                  }

                  return newValue.copyWith(text: sanitizedText);
                }),
              ],
              textInputAction: TextInputAction.next,
              autofocus: true,
              decoration: textFieldInputDecoration(
                hint: _doubleAnswerFormat.hint,
              ),
              style: TextStyle(
                color: Color.fromRGBO(2, 52, 22, 1),
              ),
              controller: _controller,
              onChanged: (String value) {
                _checkValidation(value);
              },
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
