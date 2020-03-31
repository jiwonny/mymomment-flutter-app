import 'package:flutter/material.dart';

class EditDiaryNote extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;

  EditDiaryNote({this.textEditingController, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => focusNode.requestFocus(),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 50),
        child: TextField(
          controller: textEditingController,
          focusNode: focusNode,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.grey, fontSize: 18.0),
            hintText: '오늘 내 모습은 어떤가요?',
            isDense: true,
            border: InputBorder.none
          ),
          maxLines: null,
          style: TextStyle(fontSize: 18.0, height: 1.5),
        ),
      ),
    );
  }
}
