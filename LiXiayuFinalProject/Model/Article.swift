//
//  Article.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/3/23.
//  reference: https://www.youtube.com/watch?v=_S7r9MCc2ts&t=270s

import Foundation


// Represents an array of articles in the application.
struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable{
    let name: String
}
