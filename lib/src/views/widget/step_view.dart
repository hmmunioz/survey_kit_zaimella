import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_kit/src/constants/colors.dart';
import 'package:survey_kit/src/controller/survey_controller.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/steps/step.dart' as surveystep;

class StepView extends StatelessWidget {
  final surveystep.Step step;
  final Widget title;
  final Widget child;
  final QuestionResult Function() resultFunction;
  final bool isValid;
  final SurveyController? controller;
  final bool hasMargin;

  const StepView({
    required this.step,
    required this.child,
    required this.title,
    required this.resultFunction,
    required this.hasMargin,
    this.controller,
    this.isValid = true,
  });

  @override
  Widget build(BuildContext context) {
    final _surveyController = controller ?? context.read<SurveyController>();

    return _content(_surveyController, context);
  }

  Widget _content(SurveyController surveyController, BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: Color.fromRGBO(17, 75, 95, 1).withOpacity(.2),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: title,
                ),
                child,
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        ColorsTheme.mobilmellBubleBackground),
                  ),
                  onPressed: isValid || step.isOptional
                      ? () => [
                            FocusScope.of(context).hasFocus
                                ? FocusScope.of(context).unfocus()
                                : null,
                            surveyController.nextStep(context, resultFunction),
                          ]
                      : null,
                  child: Text(
                    step.stepIdentifier.id == '0'
                        ? "Finalizar"
                        : context.read<Map<String, String>?>()?['next'] ??
                            step.buttonText ??
                            'Next',
                    style: TextStyle(
                      color: isValid
                          ? ColorsTheme.mobilmellaTitleText
                          : Colors.grey,
                    ),
                  ),
                ),
                if (hasMargin)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .35,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
