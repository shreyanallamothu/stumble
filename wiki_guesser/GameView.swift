import SwiftUI

struct Options: View {
    var option: String
    var question: Question
    @Binding var streak: Int
    @Binding var saved: Array<String>
    @Binding var highScore: Int
    @State private var tapped: Bool = false
    @Binding var gameState: GameState
    @State private var correct: Bool = false

    var body: some View {
        
        HStack {
            Button(action: {
                tapped = true
                if option == question.correct {
                    correct = true
                    streak = streak + 1
                    if streak > highScore{
                        highScore = streak
                    }
                } else {
                    gameState = .results
                }
            }) {
                Text(option)
                    .font(.jersey(size: 30))
            }
            .frame(width: 270, height: 20)
            .foregroundStyle(.black)
            .padding(20)
            .background(tapped ? (correct ? Color.green : Color.red) : Color.white)
            .border(Color.gray)
            .background(.white)
            .border(.black)
            .cornerRadius(1)
            .shadow(
                    color: Color.black.opacity(1),
                    radius: 0,
                    x: 4,
                    y: 4
                )

            Button(action: { saved.append(option) }) {
                Image("bookmark").resizable().frame(width: 50, height: 50)
            }
        }
    }
}

struct GameView: View {
    let service = Service()
    @Binding var gameState: GameState
    @Binding var streak: Int
    @Binding var saved: [String]
    @Binding var highScore: Int
    @State private var question: Question?
    @State private var shuffledOptions: [String] = []

    func loadQuestion() async {
        print("load")
        do {
            let randomPages = try await service.fetchRandomPages()
            let randomTitles = try await service.fetchRandomTitles(random: randomPages ?? [])
            question = try await service.makeQuestion(titles: randomTitles)
            if let q = question {
                shuffledOptions = [q.correct, q.incorrect_1, q.incorrect_2].shuffled()
            }
        } catch {
            print("Error fetching info: \(error)")
        }
    }

    var body: some View {
        VStack{
            HStack{
                HStack(spacing: 0){
                    Image("fire")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .padding(0)
                    
                    Text(" \(streak)").font(.jersey()).foregroundStyle(.gray)
                }
                Spacer()
                HStack(spacing: 0){
                    Image("trophy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding(0)
                    
                    Text(" \(highScore)").font(.jersey()).foregroundStyle(.gray)
                }
            }.padding(20)
            if let question = question {
                if let url = URL(string: question.correct_url) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 350)
                    } placeholder: {
                        ProgressView()
                    }
                }
                ForEach(shuffledOptions, id: \.self) { option in
                    Options(option: option, question: question, streak: $streak, saved: $saved, highScore: $highScore, gameState: $gameState)
                }
            }
            Button("End") {
                gameState = .results
            }
        }
        .task(id: streak) {
            await loadQuestion()
        }
    }
}

#Preview {
    GameView(gameState: .constant(.playing), streak: .constant(12), saved: .constant([]), highScore: .constant(15))
}
