import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_app/MVVM/model.dart';
import 'package:firebase_app/MVVM/view_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = ''; // To store the error message

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NotesScreen()),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Login Error: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email")),
              TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password")),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _login, child: Text("Login")),
              SizedBox(height: 10),
              errorMessage.isNotEmpty
                  ? Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    )
                  : Container(), // Display error if any
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAccountScreen()),
                  );
                },
                child: Text("Create Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  String errorMessage = ''; // To store the error message

  Future<void> _createAccount() async {
    try {
      if (passwordController.text.length < 6) {
        setState(() {
          errorMessage = 'Password should be at least 6 characters long.';
        });
        return;
      }
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          'username': usernameController.text,
          'email': emailController.text.trim(),
        });
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NotesScreen()),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Create Account Error: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: "Username")),
              TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email")),
              TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password")),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _createAccount, child: Text("Create Account")),
              SizedBox(height: 10),
              errorMessage.isNotEmpty
                  ? Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    )
                  : Container(), // Display error if any
            ],
          ),
        ),
      ),
    );
  }
}

class NotesScreen extends StatelessWidget {
  final NoteViewModel noteViewModel = NoteViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Note>>(
        stream: noteViewModel.fetchNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final notes = snapshot.data!;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => EditNoteScreen(note: note)),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    noteViewModel.deleteNote(note.noteId);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddNoteScreen()),
          );
        },
      ),
    );
  }
}

class AddNoteScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final noteViewModel = NoteViewModel();

    return Scaffold(
      appBar: AppBar(title: Text("Add Note")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title")),
            TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: "Content")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                noteViewModel.addNote(
                    titleController.text, contentController.text);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}

class EditNoteScreen extends StatelessWidget {
  final Note note;
  EditNoteScreen({required this.note});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final noteViewModel = NoteViewModel();

    titleController.text = note.title;
    contentController.text = note.content;

    return Scaffold(
      appBar: AppBar(title: Text("Edit Note")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title")),
            TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: "Content")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                noteViewModel.updateNote(Note(
                  noteId: note.noteId,
                  title: titleController.text,
                  content: contentController.text,
                  createdAt: note.createdAt,
                ));
                Navigator.pop(context);
              },
              child: Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
