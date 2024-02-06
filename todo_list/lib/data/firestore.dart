import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_list/models/notes_model.dart';
import 'package:uuid/uuid.dart';

class FirestoreDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser(String email) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({"id": _auth.currentUser!.uid, "email": email});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addNoteToUser(String subtitle, String title, String dueDate) async {
    try {
      var uuid = const Uuid().v4();
      DateTime date = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .set({
        'id': uuid,
        'title': title,
        'subtitle': subtitle,
        'dueDate': dueDate,
        'isDone': false,
        'time': '${date.hour}:${date.minute}',
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }


  List getNotes(AsyncSnapshot snapshot) {
    try {
      final notesList = snapshot.data.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Note(data['id'], data['subtitle'], data['time'], data['title'],
            data['isDone'],data['dueDate']);
      }).toList();
      return notesList;
    } catch (e) {
      return [];
    }
  }

  Stream<QuerySnapshot> stream(bool isDone) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('notes').where('isDone',isEqualTo:isDone)
        .snapshots();
  }

  Future<bool> isDone(String uuid, bool isDone) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({'isDone': isDone});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateNote(String uuid, String title, String subtitle, String dueDate) async {
    try {
      DateTime date = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({
        'time': '${date.hour}:${date.minute}',
        'subtitle': subtitle,
        'title': title,
        'dueDate':dueDate,
      });
      print('$title $subtitle');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> delete_note(String uuid) async {
    try{
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .delete();
      return true;
    }
    catch(e)
    {
      print(e);
      return false;
    }
  }

  Future<void> addDummyNote() async {
    // Adjust the title, subtitle, and due date for your dummy note
    const String dummyNoteTitle = 'Welcome to TodoList!';
    const String dummyNoteSubtitle = 'list your todo here';
    const String dummyDueDate = '2022-12-31'; // Replace with a default due date

    await addNoteToUser(dummyNoteSubtitle, dummyNoteTitle, dummyDueDate);
  }

}
