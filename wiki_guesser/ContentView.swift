//
//  ContentView.swift
//  wiki_guesser
//
//  Created by shreya nallamothu on 4/22/26.
//

import SwiftUI

struct ContentView: View {
    @State private var gameState: GameState = .home
    @State private var streak: Int = 0
    @State private var saved: [String] = []
    @State private var highScore: Int = 0

    
    var body: some View {
        
        switch gameState {

        case .home:
            HomeView(gameState: $gameState, highScore: $highScore)

        case .playing:
            GameView(gameState: $gameState, streak: $streak, saved: $saved, highScore: $highScore)

        case .results:
            ResultsView(gameState: $gameState, streak: $streak, saved: $saved, highScore: $highScore)
        }
    }
}
