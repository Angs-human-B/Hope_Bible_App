//
//  HopeHomeWidget.swift
//  HopeHomeWidget
//
//  Created by Ariful Wadud on 13/4/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    // Function to fetch a random verse from the Bible API
    func fetchVerse(completion: @escaping (BibleVerse?) -> Void) {
        // API endpoint for random Bible verse
        let url = URL(string: "https://labs.bible.org/api/?passage=random&type=json")!
        
        // Create and start the network request
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle network errors
            guard let data = data, error == nil else {
                print("Failed to fetch verse: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            // Parse the JSON response
            do {
                let verses = try JSONDecoder().decode([BibleAPIVerse].self, from: data)
                if let firstVerse = verses.first {
                    // Create a BibleVerse object from the API response
                    let verse = BibleVerse(
                        verse: firstVerse.text,
                        reference: "\(firstVerse.bookname) \(firstVerse.chapter):\(firstVerse.verse)"
                    )
                    completion(verse)
                } else {
                    completion(nil)
                }
            } catch {
                print("Failed to decode verse: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }

    // Provide a placeholder entry for widget gallery
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), verse: BibleVerse(
            verse: "For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life.",
            reference: "John 3:16"
        ))
    }

    // Provide a snapshot entry for widget gallery
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), verse: BibleVerse(
            verse: "For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life.",
            reference: "John 3:16"
        ))
        completion(entry)
    }

    // Provide the timeline of entries for the widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        fetchVerse { verse in
            let currentDate = Date()
            // Create entry with fetched verse or fallback to default
            let entry = SimpleEntry(
                date: currentDate,
                verse: verse ?? BibleVerse(
                    verse: "For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life.",
                    reference: "John 3:16"
                )
            )
            
            // Schedule next update in 24 hours
            let nextUpdate = Calendar.current.date(byAdding: .hour, value: 24, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

// Model for Bible verse data
struct BibleVerse: Codable {
    let verse: String
    let reference: String
}

// Entry model for the widget timeline
struct SimpleEntry: TimelineEntry {
    let date: Date
    let verse: BibleVerse
}

// Model for Unsplash API response
struct UnsplashImage: Codable {
    let urls: ImageURLs
    struct ImageURLs: Codable {
        let regular: String
    }
}

// Helper to manage background images
struct BackgroundImageManager {
    static let shared = BackgroundImageManager()
    private let cache = NSCache<NSString, NSData>()
    
    // Unsplash API endpoint for random nature/landscape images
    private let apiURL = URL(string: "https://api.unsplash.com/photos/random?query=nature,landscape&orientation=landscape")!
    
    // Your Unsplash access key
    private let accessKey = "PHxdVOQofLiiK4IaORPHnxCLT2k49QLSV_SEPScYI5U" // Replace with your actual access key
    
    func fetchRandomImage(completion: @escaping (Data?) -> Void) {
        // Check cache first
        if let cachedData = cache.object(forKey: "background" as NSString) {
            completion(cachedData as Data)
            return
        }
        
        var request = URLRequest(url: apiURL)
        request.setValue("Client-ID \(737616)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let unsplashImage = try? JSONDecoder().decode(UnsplashImage.self, from: data) else {
                completion(nil)
                return
            }
            
            // Fetch the actual image
            guard let imageURL = URL(string: unsplashImage.urls.regular) else {
                completion(nil)
                return
            }
            
            URLSession.shared.dataTask(with: imageURL) { imageData, _, _ in
                if let imageData = imageData {
                    self.cache.setObject(imageData as NSData, forKey: "background" as NSString)
                    completion(imageData)
                } else {
                    completion(nil)
                }
            }.resume()
        }.resume()
    }
}

struct HopeHomeWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            // Single background color for the entire widget
            Color(UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1.0))
            
            VStack(alignment: .leading, spacing: 6) {
                Text("DAILY VERSE")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.7))
                    .textCase(.uppercase)
                
                Text("\"\(entry.verse.verse)\"")
                    .font(.system(size: 16, weight: .regular, design: .serif))
                    .foregroundColor(.white)
                    .lineLimit(8)
                    .lineSpacing(1)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.leading)
                
                Spacer(minLength: 4)
                
                Text(entry.verse.reference)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(12)
        }
    }
}

// Main widget configuration
struct HopeHomeWidget: Widget {
    let kind: String = "HopeHomeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HopeHomeWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) {
                        Color(UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1.0))
                    }
            } else {
                HopeHomeWidgetEntryView(entry: entry)
                    .background(Color(UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1.0)))
            }
        }
        .configurationDisplayName("Daily Verse")
        .description("Display a new Bible verse each day.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// Preview provider for the widget
#Preview(as: .systemSmall) {
    HopeHomeWidget()
} timeline: {
    SimpleEntry(date: .now, verse: BibleVerse(
        verse: "For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life.",
        reference: "John 3:16"
    ))
    SimpleEntry(date: .now, verse: BibleVerse(
        verse: "Trust in the Lord with all your heart and lean not on your own understanding; in all your ways submit to him, and he will make your paths straight.",
        reference: "Proverbs 3:5-6"
    ))
}

// Model for API response
struct BibleAPIVerse: Codable {
    let text: String
    let bookname: String
    let chapter: String
    let verse: String
}