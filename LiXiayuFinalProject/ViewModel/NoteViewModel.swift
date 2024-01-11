//
//  NoteViewModel.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/3/23.
//

import Foundation
import FirebaseFirestore

// ViewModel responsible for handling note-related operations with Firestore
class NoteViewModel: ObservableObject {
    // Published array of notes that updates the UI when notes are added, updated, or removed
    @Published var notes = [Note]()
    private let db = Firestore.firestore()

    // Create a new note in Firestore for the given user
    func createNote(_ note: Note, with userId: String) async {
        // Check if the note already exists in the notes array to avoid duplicates
        if !notes.contains(where: { $0.id == note.id }) {
            notes.append(note)
            // call firestore to add note
            let noteDocument = Firestore.firestore().collection("notes").document()
            do {
               let encodedNote = try Firestore.Encoder().encode(note)
               try await noteDocument.setData(encodedNote)
            } catch let error {
               print("DEBUG: Failed to save note with error \(error.localizedDescription)")
            }
        }
    }
    
    // Update the content of an existing note in Firestore
    func updateNote(_ newNote: Note) async {
        // Ensure the note has a valid ID
        guard let noteId = newNote.id else {
            print("DEBUG: Error updating note - note ID is nil")
            return
        }

        // Get the reference to the specific note document in Firestore
        let noteDocument = db.collection("notes").document(noteId)
        
        do {
            // Encode the new note into a format that can be written to Firestore
            let encodedNote = try Firestore.Encoder().encode(newNote)
            // Update the note document in Firestore
            try await noteDocument.updateData(encodedNote)
            // Update the local notes array
            if let index = notes.firstIndex(where: { $0.id == noteId }) {
                await MainActor.run {
                    notes[index] = newNote
                }
            }
        } catch let error {
            print("DEBUG: Failed to update note with error \(error.localizedDescription)")
        }
    }

    
    // Delete a note by its ID
    func deleteNote(withId id: String) {
        // Remove the note from the local array
        notes.removeAll { $0.id == id }
        // Delete the note from Firestore
        let noteDocument = db.collection("notes").document(id)
        do {
            try noteDocument.delete()
        } catch let error {
            print("DEBUG: Failed to delete note with error \(error.localizedDescription)")
        }
    }
    
    // Load the user's notes from Firestore
    func load(with userId: String) async {
       
        do {
            // Query the "notes" collection for notes where the "userId" field matches the given user ID
            let querySnapshot = try await db.collection("notes")
                                            .whereField("userId", isEqualTo: userId)
                                            .getDocuments()

            // Map the Firestore documents to Note array
            let fetchedNotes = querySnapshot.documents.compactMap { document in
                try? document.data(as: Note.self)
            }

            // Update the notes array on the main thread
            await MainActor.run {
                self.notes = fetchedNotes
            }
        } catch {
            print("Error loading notes: \(error)")
        }
    }
    
    // Delete all notes for a given user ID
    func deleteAllNotes(for userId: String) async throws {
        let notesCollection = db.collection("notes")
        let querySnapshot = try await notesCollection.whereField("userId", isEqualTo: userId).getDocuments()
        
        for document in querySnapshot.documents {
            try await document.reference.delete()
        }
    }

}

