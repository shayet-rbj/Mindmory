//
//  EditNoteView.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/3/23.
//

import SwiftUI
import Speech

struct EditNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var noteViewModel: NoteViewModel
    @EnvironmentObject var userViewModel: AuthViewModel
    private var note: Note?
    
    // State variables for note properties
    @State private var title: String = ""
    @State private var content: String = "Enter your text here..."
    @State private var urls: String = ""
    
    // Speech recognition properties
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    // State for showing delete confirmation dialog
    @State private var showDeleteConfirmation = false

    // Initializer for the view
    init(note: Note? = nil){
        self.note = note
        if let note = note {
            _title = State(initialValue: note.title)
            _content = State(initialValue: note.content)
            _urls = State(initialValue: note.urls)
        }
    }
    var body: some View {
        VStack {
            // Input field for the note's title
            TextField("Title", text: $title)
                .font(.largeTitle)
                .padding()
            
            // Input field for the note's image URL
            HStack {
                Label("Photo link: ", systemImage: "link")
                TextField("Enter photo link here", text: $urls)
            }
            .padding()

            // Multiline text editor for the note's content
            TextEditor(text: $content)
                .padding()
            
            // Button to toggle speech recognition for dictating the note's content
            Button(action: {
                self.speechRecognizer.transcribe()
            }) {
                Text(speechRecognizer.isRecording ? "Stop Recording" : "Start Recording")
            }
            .disabled(speechRecognizer.isSpeechRecognitionDenied)
            
            Spacer()
                     
            // Conditionally show the delete button if editing an existing note
            if note != nil {
                HStack {
                    Spacer()
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                .padding(.trailing)
            }
        }
        // When the transcribed text changes, update the content
        .onReceive(speechRecognizer.$transcribedText) { newValue in
            if speechRecognizer.isRecording {
                self.content = newValue
            }
        }
        // Set the navigation bar title for the view
        .navigationBarTitle("Note", displayMode: .inline)
        .toolbar {
            // Save button with action to create or update the note
            Button ("Save"){
                Task{
                    if let note = note {
                        // update new note
                        if let userId = userViewModel.currentUser?.id {
                            await  noteViewModel.updateNote(Note(id: note.id, created: note.created, urls: urls, title: title, userId: userId, content: content))
                        } else {
                            print("DEBUG error in EditNoteView: no user id")
                        }

                    } else {
                        // create new note!
                        if let userId = userViewModel.currentUser?.id {
                            await noteViewModel.createNote(Note(urls: urls, title: title, userId: userId, content: content), with: userId)
                        } else {
                            print("DEBUG error in EditNoteView: no user id")
                            
                        }
                    }
                }
                dismiss()
            }
            .disabled(title.isEmpty || content.isEmpty || urls.isEmpty)
        }
        // Alert for delete confirmation
        .alert("Are you sure you want to delete this note?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                if let noteId = note?.id {
                    noteViewModel.deleteNote(withId: noteId)
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}



#Preview {
    NavigationStack{
        EditNoteView()
    }
}
