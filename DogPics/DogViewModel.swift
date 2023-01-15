//
//  DogViewModel.swift
//  DogPics
//
//  Created by Jeremy Taylor on 1/15/23.
//

import Foundation
@MainActor
class DogViewModel: ObservableObject {
    struct Result: Codable {
        var message: String
    }
    
    @Published var imageURL = ""
    var urlString = "https://dog.ceo/api/breeds/image/random"
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("😡 Could not create a url from \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let result = try? JSONDecoder().decode(Result.self, from: data) else {
                print("😡 JSON ERROR: Could not decode returned JSON data from \(urlString)")
                return
            }
            imageURL = result.message
            print("The imageURL is: \(imageURL)")
        } catch {
            print("😡 ERROR: Could not use URL at \(urlString) to get data & response")
        }
    }
}
