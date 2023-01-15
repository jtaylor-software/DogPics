//
//  ContentView.swift
//  DogPics
//
//  Created by Jeremy Taylor on 1/15/23.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    enum Breed: String, CaseIterable {
        case boxer, bulldog, chihuahua, corgi, labradoodle, poodle, pug, retriever
    }
    
    @StateObject var dogVM = DogViewModel()
    @State private var selectedBreed: Breed = .boxer
    @State private var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        VStack {
            Text("🐶 Dog Pics!")
                .font(Font.custom("Avenir Next Condensed", size: 60))
                .bold()
                .foregroundColor(.brown)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Spacer()
            
            AsyncImage(url: URL(string: dogVM.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .shadow(radius: 15)
                    .animation(.default, value: image)
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            }
            
            
            Spacer()
            
            Button("Any Random Dog") {
                dogVM.urlString = "https://dog.ceo/api/breeds/image/random"
                Task {
                    await dogVM.getData()
                }
            }
            .buttonStyle(.borderedProminent)
            .bold()
            .tint(.brown)
            .padding(.bottom)
            
            HStack {
                Button("Show Breed") {
                    dogVM.urlString = "https://dog.ceo/api/breed/\(selectedBreed.rawValue)/images/random"
                    Task {
                        await dogVM.getData()
                    }
                }
                .buttonStyle(.borderedProminent)
                .bold()
                .tint(.brown)
                .padding(.bottom)
                
                Picker("", selection: $selectedBreed) {
                    ForEach(Breed.allCases, id: \.self) { breed in
                        Text(breed.rawValue.capitalized)
                        
                    }
                }
            }
            .bold()
            .tint(.brown)
        }
        .padding()
        .onAppear {
            playSound(soundName: "bark")
        }
    }
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Couldn't read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioPlayer.")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
