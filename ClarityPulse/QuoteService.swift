import Foundation

struct Quote: Codable, Identifiable {
    let id: UUID
    let text: String
    let category: String
}

actor QuoteService {
    static let shared = QuoteService()
    
    private init() {}
    
    func fetchRandomQuote() async throws -> Quote? {
        guard let url = Bundle.main.url(forResource: "quotes", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }
        
        let data = try Data(contentsOf: url)
        let quotes = try JSONDecoder().decode([Quote].self, from: data)
        return quotes.randomElement()
    }
}
