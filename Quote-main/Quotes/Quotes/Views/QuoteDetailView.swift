//
//  QuoteDetailView.swift
//  QuoteDetailView
//
//  Created by Emir Byashimov on 08/12/24.
//


import SwiftUI

struct QuoteDetailView: View {
    let category: String
    @ObservedObject var quotesFetcher: QuotesFetch

    var body: some View {
        List {
            if let quotes = quotesFetcher.quotesByCategory[category] {
                ForEach(quotes) { quote in
                    VStack(alignment: .leading) {
                        Text(quote.quote)
                            .font(.headline)
                        Text("- \(quote.author)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            } else {
                Text("No quotes available for this category.")
            }
        }
        .navigationTitle(category.capitalized)
    }
}

struct QuoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
