import 'package:waveui/src/src/appraise/wave_appraise.dart';
import 'package:waveui/src/src/appraise/wave_appraise_header.dart';
import 'package:waveui/src/src/appraise/wave_appraise_config.dart';
import 'package:waveui/src/l10n/wave_intl.dart';
import 'package:flutter/material.dart';
import 'package:waveui/src/src/appraise/wave_appraise_interface.dart';

/// 描述: 评价组件bottom picker，
/// 对WaveAppraise做了一层封装，可直接使用在showDialog里面

class WaveAppraiseBottomPicker extends StatefulWidget {
  /// 标题
  final String title;

  /// 标题类型
  final WaveAppraiseHeaderType headerType;

  /// 评分组件类型，分为表情包和星星，默认星星
  final WaveAppraiseType type;

  /// 自定义文案
  /// 若评分组件为表情，则list长度为5，不足5个时请在对应位置补空字符串
  /// 若评分组件为星星，则list长度不能比count小
  final List<String>? iconDescriptions;

  /// 标签
  final List<String>? tags;

  ///输入框允许提示文案
  final String inputHintText;

  /// 提交按钮的点击回调
  final WaveAppraiseConfirmClick? onConfirm;

  /// 评价组件的配置项
  final WaveAppraiseConfig config;

  const WaveAppraiseBottomPicker({
    Key? key,
    this.title = '',
    this.headerType = WaveAppraiseHeaderType.spaceBetween,
    this.type = WaveAppraiseType.star,
    this.iconDescriptions,
    this.tags,
    this.inputHintText = '',
    this.onConfirm,
    this.config = const WaveAppraiseConfig(),
  }) : super(key: key);

  @override
  _WaveAppraiseBottomPickerState createState() => _WaveAppraiseBottomPickerState();
}

class _WaveAppraiseBottomPickerState extends State<WaveAppraiseBottomPicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.bottomCenter,
        child: WaveAppraise(
          title: widget.title,
          headerType: widget.headerType,
          type: widget.type,
          iconDescriptions: widget.iconDescriptions ?? WaveIntl.of(context).localizedResource.appriseLevel,
          tags: widget.tags,
          inputHintText: widget.inputHintText,
          onConfirm: (index, list, input) {
            if (widget.onConfirm != null) {
              widget.onConfirm!(index, list, input);
            }
          },
          config: widget.config,
        ),
      ),
    );
  }
}
