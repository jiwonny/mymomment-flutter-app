import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_face_diary/blocs/authentication_bloc/bloc.dart';
import 'package:my_face_diary/repositories/user_repository.dart';
import 'package:my_face_diary/screens/backup_screen.dart';
import 'package:my_face_diary/screens/sync_screen.dart';
import 'package:my_face_diary/utils/navigators.dart';
import 'dart:developer';
import 'package:my_face_diary/widgets/dialog/logout_confirm.dart';

class CustomDrawer extends StatelessWidget {
  final TextStyle drawerText = TextStyle(fontWeight: FontWeight.bold, fontSize: 23.0, letterSpacing: 4, height: 1.5);
  final double buttonMargin = 3.0;
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.55;
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Container(
            child: Center(
              child:
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state){
                  if(state is Authenticated){
                    return Text(state.displayName + " 님, 환영합니다.");
                  }else{
                    return Text('내 얼굴\n다이어리', textAlign: TextAlign.center, style: drawerText);
                  }
                }
              )
            )
          )
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: buttonMargin),
                  width: buttonWidth,
                  child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state){
                        if (state is Uninitialized || state is Unauthenticated){
                          return RaisedButton(
                            child: Text('구글 로그인하기'),
                            onPressed: () {
                              if(userRepository.signInWithGoogle() != null){
                                log('로그인 성공');
                                BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
                              }
                            }
                          );
                        }
                        if (state is Authenticated) {
                          return RaisedButton(
                            child: Text('로그아웃하기'),
                            onPressed: () {
                              logoutDialog(context, state.displayName);
                            },
                          );
                        }
                        return RaisedButton(
                            child: Text('예외')
                        );
                      }
                    ),
                  ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: buttonMargin),
                  width: buttonWidth,
                  child: RaisedButton(
                    child: Text('백업하기'),
                    onPressed: () => Navigator.pushNamed(context, BackupScreen.routeName),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: buttonMargin),
                  width: buttonWidth,
                  child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      builder: (context, state){
                        if (state is Authenticated) {
                          return RaisedButton(
                            child: Text('동기화하기'),
                            onPressed: () => moveToSyncScreen(context)
                          );
                        }
                        return Container();
                      }
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: buttonMargin),
                  width: buttonWidth,
                  child: RaisedButton(
                    child: Text('후원하기'),
                  ),
                ),
                Container(
                   child: Text('Version 1.0.0'),
                   margin: EdgeInsets.only(top: 20),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void logoutDialog(BuildContext context, String displayName){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutConfirm(displayName);
      },
    );
  }




}
