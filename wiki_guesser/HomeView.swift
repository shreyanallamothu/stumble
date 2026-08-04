//  HomeView.swift
//  wiki_guesser
//
//  Created by shreya nallamothu on 5/27/26.
//

import SwiftUI

struct HomeView: View {
    @Binding var gameState: GameState
    @Binding var highScore: Int

    var body: some View {
        VStack(spacing: 20) {

            Text("STUMBLE")
                .multilineTextAlignment(.center).font(.jersey(size: 120))
            Text("(keeping the internet random)").font(.jersey(size: 30))
                .multilineTextAlignment(.center).foregroundStyle(.gray)

            Button(action: {
                gameState = .playing
            }) {
                Text("START GAME")
                    .font(.jersey(size: 70))
            }.padding(10)
                    .background(.white)
                    .border(.black)
                    .cornerRadius(1)
                    .shadow(
                        color: Color.black.opacity(1),
                        radius: 0,
                        x: 10,
                        y: 10
                    )

            .buttonStyle(.plain)
            .padding(20)
            Button(action: {
                gameState = .results
            }){
                HStack{
                    Image("bookmark").resizable().frame(width: 30, height: 30)
                        .font(.system(size: 32, weight: .black))
                    Text("view saved articles").font(.jersey(size: 30))
                }
            }
            HStack(spacing: 0){
                Image("trophy").resizable().frame(width: 40, height: 40)
                Text(" high score: \(highScore)").font(.jersey(size: 30)).foregroundStyle(.gray)
            }

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HomeView(gameState: .constant(.home), highScore: .constant(20))
}
