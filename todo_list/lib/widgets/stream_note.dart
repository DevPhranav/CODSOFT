import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/widgets/task_widget.dart';

import '../data/firestore.dart';

class StreamNote extends StatelessWidget {
  bool done;
   StreamNote(this.done,{super.key});

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
        stream: FirestoreDataSource().stream(done),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
          //  return const Center(child: CircularProgressIndicator());
          }
          final noteslist = FirestoreDataSource().getNotes(snapshot);
          return ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final note=noteslist[index];
              return  Dismissible(key: UniqueKey(),onDismissed: (direction){
                FirestoreDataSource().delete_note(note.id);
              },child: TaskWidget(note));
            },
            itemCount: noteslist.length,
          );
        }
    );
  }
}
