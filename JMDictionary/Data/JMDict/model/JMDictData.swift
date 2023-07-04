//
//  JMDictData.swift
//  JDictionary
//
//  Created by Kovs on 28.02.2023.
//

import Foundation


final class JMDictData: ObservableObject {
    @Published var dictionaryData: JMDictionary?
    @Published var isLoading = false
    
    func loadData(filename: String) {
        isLoading = true
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        URLSession.shared.dataTask(with: file) { [weak self] (data, _, error) in
            guard let self = self else { return }
            self.isLoading = false
            
            if let error = error {
                fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    self.dictionaryData = try decoder.decode(JMDictionary.self, from: data)
                } catch {
                    fatalError("Couldn't parse \(filename) as \(JMDictionary.self):\n\(error)")
                }
            }
        }.resume()
    }
}
