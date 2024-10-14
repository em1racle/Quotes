//
//  MainView.swift
//  Views
//
//  Created by Emir Byashimov on 08/12/24.
//


import SwiftUI

struct MainView: View {
    @ObservedObject var quotesFetcher = QuotesFetch()

    @State private var searchText = ""

    // Filtered categories based on searchText
    var filteredCategories: [String] {
        if searchText.isEmpty {
            return Array(quotesFetcher.quotesByCategory.keys)
        } else {
            return Array(quotesFetcher.quotesByCategory.keys).filter {
                $0.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var filteredQuotes: [Quote] {
        if searchText.isEmpty {
            return quotesFetcher.quotes
        } else {
            return quotesFetcher.quotes.filter { quote in
                quote.quote.lowercased().contains(searchText.lowercased()) ||
                quote.author.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.basicBackground.ignoresSafeArea(.all)

                VStack {
                    SearchBar(searchText: $searchText)
                    Spacer()

                    ForEach(filteredCategories, id: \.self) { category in
                        if let quotes = quotesFetcher.quotesByCategory[category], !quotes.isEmpty {
                            NavigationLink(destination: QuoteDetailView(category: category, quotesFetcher: quotesFetcher)) {
                                Text(category.capitalized)
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(30)
                                    .shadow(radius: 10)
                            }
                        } else {
                            Text("No Quotes Found")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    ForEach(filteredQuotes) { quote in
                        NavigationLink(destination: QuoteDetailViewSingle(quote: quote)) {
                            VStack {
                                Text(quote.quote)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding()
                                Text("- \(quote.author)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(30)
                            .shadow(radius: 10)
                        }
                    }
                    .padding(.bottom, 40)
                }
                .padding()
            }
        }
        .onAppear {
            quotesFetcher.fetchQuotes(for: "happiness")
            quotesFetcher.fetchQuotes(for: "success")
            quotesFetcher.fetchQuotes(for: "love")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
