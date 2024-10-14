//
//  Model.swift
//  Quotes
//
//  Created by Ylyas Abdywahytow on 10/12/24.
//



import Foundation
import SwiftUI


struct Quote: Decodable, Identifiable {
    let id =  UUID()
    let quote: String
    let author: String
    let category: String
}

class QuotesFetch: ObservableObject {
    
    let apiKey = "8b3E2HX1w13LRoqNqn456Q==6sVOGIuMVlf92HEk"
   
    let apiUrl = "https://api.api-ninjas.com/v1/quotes?category="

    @Published var quotesByCategory: [String: [Quote]] = [:]
    @Published var quotes: [Quote] = []
    
    
    func fetchQuotes(for category: String) {
        let fullUrl = apiUrl + category
        
        guard let url = URL(string: fullUrl) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error:", error.localizedDescription)
                return
            }
            
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        do {
                            
                            let decodedQuotes = try JSONDecoder().decode([Quote].self, from: data)
                            DispatchQueue.main.async {
                              
                                self.quotesByCategory[category] = decodedQuotes
                            }
                        } catch {
                            print("Error decoding JSON:", error)
                        }
                    }
                } else {
                    print("Error:", httpResponse.statusCode, String(data: data ?? Data(), encoding: .utf8) ?? "")
                }
            }
        }
        
        task.resume()
    }
}



import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            TextField("Search for a quote", text: $searchText)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(10)

            Button(action: {
                searchText = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 10)
        }
        .padding()
    }
}


struct QuoteDetailViewSingle: View {
    let quote: Quote

    var body: some View {
        VStack(alignment: .center) {
            Text(quote.quote)
                .font(.title)
                .padding()

            Text("- \(quote.author)")
                .font(.subheadline)
                .padding()

            Spacer()
        }
        .navigationTitle(quote.category.capitalized)
    }
}




