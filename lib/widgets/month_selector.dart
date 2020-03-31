import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:my_face_diary/blocs/diary_bloc/bloc.dart';

//TODO(지워니) : 이쁘게 좀 꾸미자...!

class MonthSelector extends StatefulWidget {
  @override
  _MonthSelectorState createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  DateTime selectedDate;
  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => selectMonth(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(selectedDate.year.toString() + '년 ' + selectedDate.month.toString() +'월',
                style: TextStyle(fontSize: 20.0),
              ),
              Icon(Icons.arrow_drop_down, size: 24,),
            ],
          )
        )
      ],
    );
  }

  void selectMonth(BuildContext context){
    //TODO: first date & last date 수정 & selected date
    showMonthPicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 1, 5),
        lastDate: DateTime(DateTime.now().year + 1, 9),
        initialDate: selectedDate
    ).then((date) {
      if (date != null){
        setState(() {
          selectedDate = date;
        });

        BlocProvider.of<DiaryBloc>(context).add(LoadOtherDiaries(selectedDate.year, selectedDate.month));
      }
    });
  }
}
