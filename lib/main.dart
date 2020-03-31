import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_face_diary/blocs/authentication_bloc/bloc.dart';
import 'package:my_face_diary/repositories/diary_repository.dart';
import 'package:my_face_diary/repositories/user_repository.dart';
import 'package:my_face_diary/screens/backup_screen.dart';
import 'package:my_face_diary/screens/diary_edit_screen.dart';
import 'package:my_face_diary/screens/home_screen.dart';
import 'package:my_face_diary/screens/sync_screen.dart';
import 'package:my_face_diary/simple_bloc_delegate.dart';
import 'package:my_face_diary/widgets/custom_drawer.dart';
import 'package:my_face_diary/blocs/diary_bloc/bloc.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  final DiaryRepository diaryRepository = DiaryRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) => AuthenticationBloc(userRepository: userRepository)
            ..add(AppStarted()),
        ),
        BlocProvider<DiaryBloc>(
          create: (BuildContext context) => DiaryBloc(diaryRepository: diaryRepository)
            ..add(HomeScreenStarted(DateTime.now().year, DateTime.now().month)),
        ),
      ],
      child: MyApp(userRepository: userRepository, diaryRepository: diaryRepository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;
  final DiaryRepository _diaryRepository;

  MyApp({Key key, @required UserRepository userRepository, @required DiaryRepository diaryRepository})
    : assert(userRepository != null || diaryRepository != null),
      _userRepository = userRepository,
      _diaryRepository = diaryRepository,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.grey[100],
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark
    ));
    return MaterialApp(
      title: 'MyFaceDiary',
      theme: ThemeData(
          canvasColor: Colors.grey[100],
          brightness: Brightness.light,
          fontFamily: 'NanumBarunGothic',
          appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: Colors.grey[100],
          elevation: 0
        )
      ),
      home: MyHomePage(title: 'My Face Diary'),
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        DiaryEditScreen.routeName: (context) => DiaryEditScreen(),
        BackupScreen.routeName: (context) => BackupScreen(),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _mainScaffoldKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        key: _mainScaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('MY MOMMENT',
            style: TextStyle(color: Color(0xffff6f6e), fontSize: 28.0,
                 fontWeight: FontWeight.w700),
          ),
          centerTitle: false,
          actions: <Widget>[
            Builder(
              builder: (c) => InkWell(
                onTap: () => _openDrawer(c),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox.fromSize(
                      size: Size(25.0, 25.0),
                      child: SvgPicture.asset('assets/icons/user.svg', color: Color(0xffff6f6e),)),
                ),
              ),
            )
          ],
        ),
        endDrawer: Drawer(
          child: CustomDrawer(),
        ),
        body: HomeScreen(),
      ),
    );
  }

  void _openDrawer(BuildContext context){
    return Scaffold.of(context).openEndDrawer();
  }

}