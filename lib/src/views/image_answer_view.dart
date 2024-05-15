import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:survey_kit/src/answer_format/image_answer_format.dart';
import 'package:survey_kit/src/result/question/image_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

class ImageAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final ImageQuestionResult? result;

  const ImageAnswerView({
    Key? key,
    required this.questionStep,
    required this.result,
  }) : super(key: key);

  @override
  State<ImageAnswerView> createState() => _ImageAnswerViewState();
}

class _ImageAnswerViewState extends State<ImageAnswerView> {
  late final ImageAnswerFormat _imageAnswerFormat;
  late final DateTime _startDate;

  bool _isValid = false;
  String filePath = '';

  @override
  void initState() {
    super.initState();
    _imageAnswerFormat = widget.questionStep.answerFormat as ImageAnswerFormat;
    _startDate = DateTime.now();
    if ((widget.result?.result ?? '').isNotEmpty) {
      filePath = widget.result?.result ?? '';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: widget.questionStep,
      hasMargin: true,
      resultFunction: () => ImageQuestionResult(
        id: widget.questionStep.stepIdentifier,
        startDate: _startDate,
        endDate: DateTime.now(),
        valueIdentifier: filePath,
        result: filePath,
      ),
      isValid: _isValid || widget.questionStep.isOptional,
      title: widget.questionStep.title.isNotEmpty
          ? Text(
              widget.questionStep.title,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            )
          : widget.questionStep.content,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              if (filePath.isNotEmpty ||
                  (widget.result?.result ?? '').isNotEmpty)
                Image(
                  height: MediaQuery.of(context).size.height * .25,
                  image: FileImage(File(filePath.isNotEmpty
                      ? filePath
                      : (widget.result?.result ?? ''))),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 8.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _optionsDialogBox();
                      },
                      child: Text(_imageAnswerFormat.buttonText),
                    ),
                    if (filePath.isNotEmpty ||
                        (widget.result?.result ?? '').isNotEmpty)
                      Text(
                        filePath.isNotEmpty
                            ? filePath
                                .split('/')[filePath.split('/').length - 1]
                            : (widget.result?.result ?? '').split('/')[
                                (widget.result?.result ?? '')
                                        .split('/')
                                        .length -
                                    1],
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Tomar una foto'),
                  onTap: () {
                    if (_imageAnswerFormat.hintImage != null &&
                        _imageAnswerFormat.hintTitle != null) {
                      context.pop();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            _imageAnswerFormat.hintTitle.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                          content: Image.network(
                            _imageAnswerFormat.hintImage.toString(),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  _openCamera();
                                },
                                child: Text('Abrir Cámara')),
                          ],
                        ),
                      );
                    } else {
                      context.pop();
                      _openCamera();
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                _imageAnswerFormat.useGallery
                    ? GestureDetector(
                        child: Text('Seleccionar de galería'),
                        onTap: () {
                          context.pop();
                          _openGallery();
                        },
                      )
                    : SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openCamera() async {
    Container();

    var picture = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    //Navigator.pop(context);

    picture?.readAsBytes().then((value) {
      setState(() {
        filePath = picture.path;
      });
    });
  }

  Future<void> _openGallery() async {
    var picture = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    //Navigator.pop(context);

    picture?.readAsBytes().then((value) {
      setState(() {
        filePath = picture.path;
      });
    });
  }
}
