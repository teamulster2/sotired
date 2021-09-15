import 'package:flutter/material.dart';
import 'package:so_tired/ui/core/home/home.dart';
import 'package:so_tired/ui/core/navigation/navigation.dart';
import 'package:so_tired/ui/core/navigation/navigation_drawer.dart';
import 'package:so_tired/ui/models/dialog_objects.dart';
import 'package:so_tired/ui/modules/pvt_test/pvt_test.dart';
import 'package:so_tired/ui/modules/self_assessment/self_assessment.dart';
import 'package:so_tired/ui/modules/self_test_engine/self_test_engine.dart';
import 'package:so_tired/ui/modules/self_test_engine/self_test_state.dart';
import 'package:so_tired/ui/modules/spatial_span_test/spatial_span_test.dart';

class SelfTest extends StatefulWidget {
  const SelfTest({Key? key}) : super(key: key);

  @override
  _SelfTestState createState() => _SelfTestState();
}

class _SelfTestState extends State<SelfTest> {
  late SelfTestEngine engine;

  @override
  Widget build(BuildContext context) {
    engine = SelfTestEngine(StartSelfTestState(), (ProgressDialogObject pdo) {
      showProgressDialog(pdo);
    });

    Future<dynamic>.delayed(Duration.zero, () => engine.handleState());
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: NavigationBar(),
      ),
      drawer: const NavigationDrawer(),
      body: ValueListenableBuilder<SelfTestState>(
          valueListenable: engine.currentState,
          builder: (BuildContext builder, Object? value, Widget? widget) =>
              Container(
                  color: Theme.of(context).backgroundColor,
                  child: setContent())),
    );
  }

  Widget setContent() {
    if (engine.currentState.value.toString() ==
        SelfAssessmentState().toString()) {
      return SelfAssessment(
        onFinished: () => engine.handleState(),
      );
    } else if (engine.currentState.value.toString() ==
        SpatialSpanTaskState().toString()) {
      return SpatialSpanTest(
        onFinished: () => engine.handleState(),
      );
    } else if (engine.currentState.value.toString() == PVTState().toString()) {
      return PVTTest(onFinished: () => engine.handleState());
    }
    return Container();
  }

  void showProgressDialog(ProgressDialogObject pdo) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding:
                    const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        height: 70,
                        width: 400,
                        padding: const EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(pdo.progress,
                            style: Theme.of(context).textTheme.headline3)),
                    const SizedBox(height: 20),
                    Text(
                      pdo.title,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      pdo.content,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            pdo.onCancel();
                            Navigator.push(
                                context,
                                MaterialPageRoute<BuildContext>(
                                    builder: (BuildContext context) =>
                                        const Home()));
                          },
                        ),
                        TextButton(
                          child: const Text('Ok'),
                          onPressed: () {
                            pdo.onOk();
                            if (pdo.onOkPush) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<BuildContext>(
                                      builder: (BuildContext context) =>
                                          const Home()));
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }
}