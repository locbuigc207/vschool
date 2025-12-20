import 'package:flutter/material.dart';
import 'package:vschool/commons/models/schedule/schedule_model.dart';
import 'package:vschool/gen/colors.gen.dart';

class ScheduleTable extends StatefulWidget {
  final String sessionOfDay;
  final List<ScheduleModel> lstData;

  const ScheduleTable(
      {Key? key, required this.sessionOfDay, required this.lstData})
      : super(key: key);

  @override
  State<ScheduleTable> createState() => _ScheduleTableState();
}

class _ScheduleTableState extends State<ScheduleTable> {
  List<String> dayOfWeek = [
    '',
    'T2',
    'T3',
    'T4',
    'T5',
    'T6',
    'T7',
    'CN',
  ];

  List<String> tiet = [
    'Tiết 1',
    'Tiết 2',
    'Tiết 3',
    'Tiết 4',
    'Tiết 5',
    'Tiết 6',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          decoration: const BoxDecoration(
            color: ColorName.primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.sessionOfDay,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        widget.lstData.isNotEmpty
            ? Table(
                border: TableBorder.all(),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: List<TableRow>.generate(
                  tiet.length,
                  (indexRow) => TableRow(
                    children: List<Widget>.generate(
                      dayOfWeek.length,
                      (indexCol) => SizedBox(
                        height: 50,
                        width: 50,
                        child: Center(
                          child: indexCol == 0
                              ? Text(
                                  tiet[indexRow],
                                  style: const TextStyle(
                                      color: ColorName.blue,
                                      fontWeight: FontWeight.bold),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (int i = 0;
                                        i < widget.lstData.length;
                                        i++)
                                      indexRow ==
                                                  widget.lstData[i].eIndex &&
                                              indexCol ==
                                                  widget.lstData[i].sIndex
                                          ? Flexible(
                                              flex: 5,
                                              child: Text(
                                                widget.lstData[i].subjectName,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 6,
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Table(
                border: TableBorder.all(),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: List<TableRow>.generate(
                  tiet.length,
                  (indexRow) => TableRow(
                    children: List<Widget>.generate(
                      dayOfWeek.length,
                      (indexCol) => SizedBox(
                        height: 50,
                        width: 50,
                        child: Center(
                          child: indexCol == 0
                              ? Text(
                                  tiet[indexRow],
                                  style: const TextStyle(
                                      color: ColorName.blue,
                                      fontWeight: FontWeight.bold),
                                )
                              : const Text(
                                  '',
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
