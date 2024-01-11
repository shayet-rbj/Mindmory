//
//  CommunityView.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/3/23.


import SwiftUI
import UIKit
import SafariServices

struct CommunityView: View {
    @StateObject var blogViewModel = BlogsViewModel()
    @State private var searchTerm: String = ""

    var body: some View {
        NavigationStack {
            // List displays articles fetched from the BlogsViewModel
            List(blogViewModel.communityArticles.articles,  id: \.title) { article in
                // Each article is presented as a navigation link leading to a Safari view displaying the article's content
                NavigationLink(destination: SafariView(url: URL(string: article.url ?? "")!)
                    .navigationBarTitleDisplayMode(.inline)
                ){
                    NewsCellView(article: article)
                }
                
            }
            .navigationBarTitle("Articles")
            .onAppear {
                Task{
                    await blogViewModel.getTopStories()
                }

            }
            .searchable(text: $searchTerm)
            .onChange(of: searchTerm) {
                Task {
                    await blogViewModel.search(with: searchTerm)
                }
            }
        }
    }
}


// SafariView wraps a SFSafariViewController to show a web page within the app
struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}

#Preview {
    CommunityView()
}
