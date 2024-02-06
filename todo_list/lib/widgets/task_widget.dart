import 'package:flutter/material.dart';
import 'package:todo_list/const/colors.dart';
import 'package:todo_list/data/firestore.dart';
import 'package:todo_list/screens/edit_note_screen.dart';

import '../models/notes_model.dart';

class TaskWidget extends StatefulWidget {
  Note _note;

  TaskWidget(this._note, {super.key});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {


  @override
  Widget build(BuildContext context) {
    bool isDone = widget._note.isDone;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Container(
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 2),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              images(),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget._note.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Checkbox(
                          value: isDone,
                          onChanged: (value) {
                            setState(() {
                              isDone = !isDone;
                            });
                            FirestoreDataSource()
                                .isDone(widget._note.id, isDone);
                          },
                          checkColor: Colors.white,
                          activeColor: Colors.lightGreen,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget._note.subtitle,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const Spacer(),
                    edit_time(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget edit_time() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              width: 90,
              height: 28,
              decoration: BoxDecoration(
                color: customGreen,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                   Text("Due:",style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        formatDueDate(widget._note.dueDate),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>  EditNote(widget._note)));
            },
            child: Container(
              width: 90,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.lightGreen.shade50,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    Image.asset('images/edit_icon.png'),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'edit',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatDueDate(String dueDate) {
    DateTime parsedDate = DateTime.parse(dueDate).toLocal(); // Convert to local time
    DateTime today = DateTime.now().toLocal(); // Convert to local time
    DateTime tomorrow = today.add(Duration(days: 1));

    if (parsedDate.year == today.year &&
        parsedDate.month == today.month &&
        parsedDate.day == today.day) {
      return 'Today';
    } else if (parsedDate.year == tomorrow.year &&
        parsedDate.month == tomorrow.month &&
        parsedDate.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return dueDate;
    }
  }
  Widget images() {
    return Container(
      margin: const EdgeInsets.only(bottom: 70),
      height: 30,
      width: 30,
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('images/login_image.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


