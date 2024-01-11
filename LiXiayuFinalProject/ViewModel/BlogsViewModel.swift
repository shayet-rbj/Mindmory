//
//  BlogsViewModel.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/3/23.
//

import Foundation

// ViewModel responsible for fetching and handling blog articles data.
class BlogsViewModel: ObservableObject {
    // URL for fetching top headlines in the US.
    private let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=US&apiKey=81db1a385f914605a47551e41c6a8a79")
    // Base URL for searching articles, sorted by popularity.
    private let searchUrlString = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=81db1a385f914605a47551e41c6a8a79&q="
    
    @Published var communityArticles = APIResponse(articles: [])
    
    init(){}


    // Fetches top stories from the news API.
    func getTopStories() async {
        // Build the URL for the GET request
        guard let url = topHeadlinesURL else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            // Decode the JSON into an array of articles
            let decoder = JSONDecoder()
            communityArticles = try decoder.decode(APIResponse.self, from: data)
        } catch {
            print("DEBUG Error fetching articles: \(error)")
        }

    }
    
    // Searches for articles based on a query string.
    func search(with query: String) async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let searchUrl = URL(string: "\(searchUrlString)\(query)")
        
        guard let url = searchUrl else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            // Decode the JSON into an array of Photos
            let decoder = JSONDecoder()
            communityArticles = try decoder.decode(APIResponse.self, from: data)
        } catch {
            print("DEBUG Error search articles: \(error)")
        }
    }
}
