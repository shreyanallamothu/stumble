//
//  HomeView.swift
//  wiki_guesser
//
//  Created by shreya nallamothu on 5/27/26.
//

import SwiftUI

struct ResultsView: View {
    @Binding var gameState: GameState
    @Binding var streak: Int
    @Binding var saved:  [String]
    @State private var showingSheet = false
    @Binding var highScore: Int

    
    var body: some View {
        VStack{
            Text("GAME OVER")
                .multilineTextAlignment(.center).font(.jersey(size: 120))
            
            HStack(spacing: 0){
                Image("fire").resizable().frame(width: 80, height: 80)
                Text("streak: \(streak)").font(.jersey())
            }
            HStack(spacing: 0){
                Image("trophy").resizable().frame(width: 80, height: 80)
                Text("high score: \(highScore)").font(.jersey())
            }
            
            Button(action: {
                showingSheet.toggle()
            }){
                HStack{
                    Image("bookmark").resizable().frame(width: 30, height: 30)
                        .font(.system(size: 32, weight: .black))
                    Text("view saved articles").font(.jersey(size: 30))
                }
            }
            Button("PLAY AGAIN"){
                gameState = .playing
            }.font(.jersey(size: 30)).foregroundStyle(.black).padding(20).border(.black)
        }.sheet(isPresented: $showingSheet){
            SavedArticlesView(saved: $saved)
        }
    }
}

#Preview {
    ResultsView(
        gameState: .constant(.results),
        streak: .constant(12),
        saved: .constant(["Moon"]),
        highScore: .constant(15)
    )
}
