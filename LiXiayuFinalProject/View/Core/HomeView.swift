//
//  HomeView.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/2/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userViewModel: AuthViewModel
    @StateObject var noteViewModel = NoteViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), 
                                    GridItem(.flexible())],
                                    spacing: 20) {

                    // The button for creating a new note
                    NavigationLink(destination: EditNoteView().environmentObject(noteViewModel)) {
                        VStack {
                            Image(systemName: "plus.circle")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                            Text("New note")
                                .foregroundColor(.blue)
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 280)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    
                    // Iterates over the collection of notes and creates a card view for each
                    ForEach(noteViewModel.notes) { note in
                        NavigationLink(destination: EditNoteView(note: note).environmentObject(noteViewModel)) {
                            CardView(note: note)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
                .navigationTitle("Mindmory")
                .onAppear() {
                    print("HomeView appeared.")
                    Task{
                        guard let userId = userViewModel.currentUser?.id else {
                            print("no userId")
                            return
                        }
                        
                        await noteViewModel.load(with: userId)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
    
}
