import 'package:example/sample/widgets.dart';
import 'package:waveui/waveui.dart';

class TextValueArrowContentExample extends StatefulWidget {
  const TextValueArrowContentExample({super.key});

  @override
  _TextValueArrowContentExampleState createState() => _TextValueArrowContentExampleState();
}

class _TextValueArrowContentExampleState extends State<TextValueArrowContentExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const WaveAppBar(
        title: 'value带有操作箭头',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '规则',
              style: TextStyle(color: Color(0xFF222222), fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const WaveBubbleText(
              maxLines: 4,
              text: 'value带有操作箭头，箭头在最右侧，value单行展示',
            ),
            const Text(
              '正常案例',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WavePairInfoTable(
              isValueAlign: false,
              children: <WaveInfoModal>[
                WaveInfoModal(
                    keyPart: "名称：",
                    valuePart: "内容内容内容内容",
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
                WaveInfoModal(
                    keyPart: "名称名：",
                    valuePart: "内容内容内容内容内容",
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
                WaveInfoModal.keyOrValueLastQuestionInfo("名称名称名称", "内容内容内容内容内容",
                    keyShow: true,
                    valueShow: true,
                    keyCallback: () {
                      showSnackBar(context, msg: 'key question');
                    },
                    valueCallback: () {
                      showSnackBar(context, msg: 'value question');
                    },
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
                WaveInfoModal.valueLastClickInfo("名称名称名称", "内容内容内容内容内容", "超链接",
                    clickCallback: (value) {
                      showSnackBar(context, msg: value!);
                    },
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
              ],
            ),
            const Text(
              '正常案例',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WavePairInfoTable(
              isValueAlign: true,
              children: <WaveInfoModal>[
                WaveInfoModal(
                    keyPart: "名称：",
                    valuePart: "内容内容内容内容",
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
                WaveInfoModal(
                    keyPart: "名称名：",
                    valuePart: "内容内容内容内容内容",
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
                WaveInfoModal.keyOrValueLastQuestionInfo("名称名称名称", "内容内容内容内容内容",
                    keyShow: true,
                    valueShow: true,
                    keyCallback: () {
                      showSnackBar(context, msg: 'key question');
                    },
                    valueCallback: () {
                      showSnackBar(context, msg: 'value question');
                    },
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
                WaveInfoModal.valueLastClickInfo("名称名称名称", "内容内容内容内容内容", "超链接",
                    clickCallback: (value) {
                      showSnackBar(context, msg: value!);
                    },
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    })
              ],
            ),
            const Text(
              '异常案例正常案例 key过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WavePairInfoTable(
              isValueAlign: false,
              children: <WaveInfoModal>[
                WaveInfoModal(
                    keyPart: "名称：",
                    valuePart: "内容内容内容内容",
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
                WaveInfoModal(
                    keyPart: "名称名：",
                    valuePart: "内容内容内容内容内容",
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
                WaveInfoModal.keyOrValueLastQuestionInfo("名称名称名称名称名称名名称名称名称名称", "内容内容内容内容内容",
                    keyShow: true,
                    valueShow: true,
                    keyCallback: () {
                      showSnackBar(context, msg: 'key question');
                    },
                    valueCallback: () {
                      showSnackBar(context, msg: 'value question');
                    },
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
              ],
            ),
            const Text(
              '异常案例正常案例 key过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WavePairInfoTable(
              isValueAlign: true,
              children: <WaveInfoModal>[
                WaveInfoModal(
                    keyPart: "名称：",
                    valuePart: "内容内容内容内容",
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
                WaveInfoModal(
                    keyPart: "名称名：",
                    valuePart: "内容内容内容内容内容",
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
                WaveInfoModal.keyOrValueLastQuestionInfo("名称名称名称名称名称名名称名称名称名称", "内容内容内容内容内容",
                    keyShow: true,
                    valueShow: true,
                    keyCallback: () {
                      showSnackBar(context, msg: 'key question');
                    },
                    valueCallback: () {
                      showSnackBar(context, msg: 'value question');
                    },
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
              ],
            ),
            const Text(
              '异常案例正常案例 内容过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WavePairInfoTable(
              isValueAlign: true,
              children: <WaveInfoModal>[
                WaveInfoModal(
                    keyPart: "名称：",
                    valuePart: "内容内容内容内容",
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
                WaveInfoModal(
                    keyPart: "名称名：",
                    valuePart: "内容内容内容内容内容",
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
                WaveInfoModal.keyOrValueLastQuestionInfo("名称名称名", "内容内容内容内容内容内容内容内容内容内容",
                    keyShow: true,
                    valueShow: true,
                    keyCallback: () {
                      showSnackBar(context, msg: 'key question');
                    },
                    valueCallback: () {
                      showSnackBar(context, msg: 'value question');
                    },
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
              ],
            ),
            const Text(
              '异常案例正常案例 内容过长',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 28,
              ),
            ),
            WavePairInfoTable(
              isValueAlign: false,
              children: <WaveInfoModal>[
                WaveInfoModal(
                    keyPart: "名称：",
                    valuePart: "内容内容内容内容",
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
                WaveInfoModal(
                    keyPart: "名称名：",
                    valuePart: "内容内容内容内容内容",
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
                WaveInfoModal.keyOrValueLastQuestionInfo("名称名称名", "内容内容内容内容内容内容内容内容内容内容",
                    keyShow: true,
                    valueShow: true,
                    keyCallback: () {
                      showSnackBar(context, msg: 'key question');
                    },
                    valueCallback: () {
                      showSnackBar(context, msg: 'value question');
                    },
                    isArrow: true,
                    valueClickCallback: () {
                      showSnackBar(context, msg: '内容内容内容内容');
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
