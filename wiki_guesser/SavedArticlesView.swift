//
//  SavedArticlesView.swift
//  wiki_guesser
//
//  Created by shreya nallamothu on 5/28/26.
//

import SwiftUI

struct Saved: View{
    var service: Service
    var articleName: String
    @State private var articleImageLink: String = ""
    var pageLink: String {
            "https://en.wikipedia.org/wiki/" + articleName
        }

    
    var body: some View{
        Link(destination: URL(string: pageLink)!){
            VStack(alignment: .leading){
                HStack(spacing: 30){
                    AsyncImage(url: URL(string: articleImageLink)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .cornerRadius(20)

                    } placeholder: {
                        ProgressView()
                    }
                    VStack(alignment: .leading){
                        Text(articleName).font(.jersey(size: 40))
                        Text("read wikipedia article ->").font(.jersey(size: 20)).foregroundStyle(.blue)
                    }
                }.padding(12)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .border(.black)
                    .cornerRadius(1)
                    .shadow(
                        color: Color.black.opacity(1),
                        radius: 0,
                        x: 4,
                        y: 4
                    )
            }.task{
                do{
                    articleImageLink = try await service.fetchURL(title: articleName)
                } catch{
                    articleImageLink = "error loading saved article"
                }
            }
        }
    }
    
}

struct SavedArticlesView: View {
    let service = Service()

    @Binding var saved: [String]

    var body: some View {
        HStack(spacing: 18) {
            Image("folder")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)

            Text("SAVED")
                .font(.jersey(size: 90))
        }.padding(0)
        Text("the rabbit hole starts here").font(.jersey(size: 30))
        List{
            ForEach(saved, id: \.self) { string in
                Saved(service: service, articleName: string)
            }.onDelete(perform: {offsets in saved.remove(atOffsets: offsets)})
        }.listStyle(.plain)
            .scrollContentBackground(.hidden)
    }
}


#Preview {
    SavedArticlesView(saved: .constant(["Moon", "Mona Lisa"]))
}
