import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_face_diary/blocs/authentication_bloc/bloc.dart';
import 'package:my_face_diary/repositories/user_repository.dart';
import 'package:toast/toast.dart';

class LogoutConfirm extends StatelessWidget {

  final String displayName;
  LogoutConfirm(this.displayName);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state){
        if(state is Unauthenticated){
          Toast.show('로그아웃 되었습니다.', context, duration: Toast.LENGTH_LONG);
          Navigator.pop(context);
        }else{
          Toast.show('로그아웃 실패', context);
          Navigator.pop(context);
        }
      },
      child: AlertDialog(
        title: Text("로그아웃"),
        content: Text(displayName + "님, 로그아웃 하시겠습니까?"),
        actions: [
          cancelButton(context),
          continueButton(context),
        ],
      ),
    );
  }

  // set up the buttons
  Widget cancelButton(BuildContext context){
    return  FlatButton(
      child: Text("취소"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget continueButton(BuildContext context){
    return FlatButton(
      child: Text("확인"),
      onPressed:  () {
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
      },
    );
  }
}

