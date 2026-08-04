//
//  Service.swift
//  wiki_guesser
//
//  Created by shreya nallamothu on 4/22/26.
//

import SwiftUI

import Foundation

struct WikiResponse: Codable {
    let batchcomplete: String
    let query: Query
}

// MARK: - Query
struct Query: Codable {
    let pages: [String: Page]
}

struct Page: Codable {
    let pageid: Int
    let ns: Int
    let title: String
    let thumbnail: Thumbnail?
    let pageimage: String?
}

struct Thumbnail: Codable {
    let source: String
    let width: Int
    let height: Int
}

struct RandomResponse: Codable{
    let query: RandomQuery
}

struct RandomQuery: Codable{
    let random: [Random]
}

struct Random: Codable{
    let id: Int
    let ns: Int
    let title: String
}

struct Question{
    let id = UUID()
    let correct: String
    let correct_url: String
    let incorrect_1: String
    let incorrect_2: String
}




class Service {
    func fetchRandomPages() async throws -> [Random]? { // gets three random wikipedia pages
        let url = URL(string: "https://en.wikipedia.org/w/api.php?action=query&list=random&rnlimit=3&rnnamespace=0&format=json")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let info = try JSONDecoder().decode(RandomResponse.self, from: data)
            
            print("SUCCESS:", info.query.random)
            
            return info.query.random
            
        } catch {
            print("ERROR:", error)
            return nil
        }
    }
    
    func fetchRandomTitles(random: [Random]) async throws -> [String] { // gets image names given list of random wikipedia pages
        var titles: [String] = []
        random.forEach{
            random in
            titles.append(random.title)
        }
        return titles
    }
    
    func fetchURL(title: String) async throws -> String{ // helper function that gets image url given page name
        let url = URL(string: "https://en.wikipedia.org/w/api.php?action=query&titles=" + title + "&prop=pageimages&format=json&pithumbsize=400")!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        let info = try? JSONDecoder().decode(WikiResponse.self, from: data)
        
        if let info{
            if let firstPage = info.query.pages.values.first {
                if let thumbnail = firstPage.thumbnail{
                    return thumbnail.source
                }
                return "This page has no thumbnail image available" // here you can recall the function etc
            }
            return "No pages found"
        }
        return "not working"
        
        
    }
    
    func makeQuestion(titles: [String]) async throws -> Question{ // given a list of titles, returns trivia question
        let correct = titles[0]
        let incorrect_1 = titles[1]
        let incorrect_2 = titles[2]
        
        let imageURL = try await fetchURL(title: correct)
        if imageURL == "This page has no thumbnail image available"{
            let pages = try await fetchRandomPages() ?? []
            let titles = try await fetchRandomTitles(random: pages)
            return try await makeQuestion(titles: titles)
        }
        let question = Question(correct: correct, correct_url: imageURL, incorrect_1: incorrect_1, incorrect_2: incorrect_2)
        return question
    }

    
    
    
}
