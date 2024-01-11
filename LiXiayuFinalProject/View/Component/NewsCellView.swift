//
//  NewsCellView.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/5/23.
//

import SwiftUI

struct NewsCellView: View {
    let article: Article
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            // If the article has an image URL, it is displayed using AsyncImage
            if let imageData = article.urlToImage {
                AsyncImage(url: URL(string: imageData)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                .cornerRadius(10)
                .frame(width: 100, height: 100, alignment: .trailing)
            }else {
                Rectangle()
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            }
            
            Spacer()
            
            // VStack for article title and description
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                    .truncationMode(.tail)
                Text(article.description ?? "")
                    .font(.subheadline)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
                
        }
    }
}

