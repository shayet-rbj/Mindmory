//
//  AuthViewModel.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/3/23.
//  reference: https://www.youtube.com/watch?v=QJHmhLGv-_0

import Foundation
import Firebase
import FirebaseFirestore

// Protocol to ensure that a form (e.g., for sign in or sign up) has valid inputs
protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

// ViewModel responsible for handling authentication tasks
@MainActor
class AuthViewModel: ObservableObject{
    // Holds the current session of the Firebase authenticated user
    @Published var userSession: FirebaseAuth.User? = nil
    // Holds the custom User object with details from Firestore
    @Published var currentUser: User? = nil
    @Published var isUserAuthenticated = false
    
    init(){
        self.userSession = Auth.auth().currentUser
        
        Task{
            await fetchUser()
        }
    }
    
    // Asynchronously sign in a user with email and password
    func signIn(withEmail email: String, password: String) async throws {
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            self.isUserAuthenticated = true
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
            throw error
        }
    }
    
    // Asynchronously create a new user with email, password, and fullname
    func createUser(withEmail email: String, password: String, fullname: String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
            self.isUserAuthenticated = true
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    // Sign out the current user
    func signOut(){
        do {
            try Auth.auth().signOut() // signs out user on backend
            self.userSession = nil // wipes out user session and takes us back to login screen
            self.currentUser = nil
            self.isUserAuthenticated = false
        } catch{
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
            
        }
    }
    
    // delete the current user's account
    func deleteAccount() async {
        do {
            guard let user = Auth.auth().currentUser else { return }
            
            // Initialize NoteViewModel to access note deletion functionality
            let noteVM = NoteViewModel()
            // Delete all notes associated with the user
            try await noteVM.deleteAllNotes(for: user.uid)

            // Delete the user's data from Firestore colletion first
            try await Firestore.firestore().collection("users").document(user.uid).delete()

            // Delete the user from Firebase Authentication
            try await user.delete()

            // Sign out the user to complete the deletion process
            try Auth.auth().signOut()
            
            // Update local user session state
            self.userSession = nil
            self.currentUser = nil
            self.isUserAuthenticated = false
            
            

        } catch {
            print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
        }
        
    }
    
    // Fetch the current user's details from Firestore
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        
        self.currentUser = try? snapshot.data(as: User.self)
        
//        print("DEBUG: Current user is \(self.currentUser)")
    }
}
