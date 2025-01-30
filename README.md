# Flutter---Notes-APP
A simple note-taking app built with Flutter and Firebase. It allows users to sign up, log in, and manage their notes (create, edit, delete) with Firebase Authentication and Firestore integration. Uses MVVM architecture and Provider for state management.

Note-Taking App with Firebase
This is a simple and functional note-taking app built with Flutter and integrated with Firebase for authentication and data storage. The app allows users to create, edit, delete, and view notes securely. Firebase Authentication is used for user login, and Firestore is used to store and manage the notes.

Features:
User Authentication: Users can sign up and log in with their email and password using Firebase Authentication.
CRUD Operations for Notes:
Users can create, read, update, and delete notes.
Notes are stored in Firebase Firestore.
Notes List: After logging in, users can view a list of their saved notes.
Add/Edit Notes: Users can create new notes and edit existing ones.
State Management: The app uses Provider for managing authentication state and note list state.
Firestore Integration: Notes are stored under the authenticated user's UID in Firestore.
MVVM Architecture:
The app follows the MVVM (Model-View-ViewModel) pattern:

Model: Represents the Note data structure (Note class).
View: UI screens (login screen, home screen, add/edit note screen).
ViewModel: Logic for handling Firebase operations (authentication, CRUD operations for notes).
Setup Instructions:
Set up a Firebase project, enable Firebase Authentication and Firestore.
Add the necessary Firebase configurations to the Flutter project.
Clone this repository and run the app on your device or emulator.
Firebase Firestore Rules:
Ensure your Firestore rules are configured to allow access only to authenticated users. Example:

json
Copy
Edit
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
Technologies Used:
Flutter: Framework for building the app.
Firebase Authentication: For user login and signup.
Firebase Firestore: For storing and retrieving notes.
Provider: For state management.
