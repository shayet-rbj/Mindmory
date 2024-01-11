//
//  CardView.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/3/23.
//

import SwiftUI

// A view component representing a card-style layout for displaying a note.
struct CardView: View {
    // The note data to be displayed in the card.
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            // image
            AsyncImage(url: URL(string: note.urls)) { image in
                image
                    .resizable()
                    .aspectRatio( contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width / 2 - 50, height: 150)
                    .clipped()
            } placeholder: {
                Color.gray // Placeholder in case the image is not loaded
            }
            .cornerRadius(10)

            // title
            Text(note.title)
                .font(.headline)
                .lineLimit(1)
                .foregroundColor(.black)
            
            // content
            Text(note.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // date
            if let createdDate = note.created {
                Text(createdDate, style: .date) // Display the formatted date
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // tage
            HStack {
                Image(systemName: "tag")
                Text("#Tag")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .frame(width: UIScreen.main.bounds.width / 2 - 20, height: 280)
    }
}

#Preview {
    CardView(note:
                Note(id: "1",
                     created: Date(),
                     urls:  "https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGhvdG98ZW58MHx8MHx8fDA%3D",
                     title: "my title", userId: "",
                     content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry."))
}
