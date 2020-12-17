import 'package:flutter/material.dart';

@immutable
class MessageModel {
  final String title;
  final String body;

  const MessageModel({
    @required this.title,
    @required this.body,
  });
}
