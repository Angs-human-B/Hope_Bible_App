//
//  HopeHomeWidget.swift
//  HopeHomeWidget
//
//  Created by Ariful Wadud on 13/4/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let userDefaults = UserDefaults(suiteName: "group.com.hope.app")
    let appGroupID = "group.com.hope.app"
    
    init() {
        // Check app group access on initialization
        if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) {
            print("Widget can access app group container at: \(containerURL.path)")
        } else {
            print("Widget CANNOT access app group container - please check entitlements")
        }
        
        if let defaults = userDefaults {
            print("Widget can initialize UserDefaults with app group")
            // Print all available keys
            let allKeys = defaults.dictionaryRepresentation().keys
            print("Available keys in UserDefaults: \(allKeys.joined(separator: ", "))")
        } else {
            print("Widget CANNOT initialize UserDefaults with app group")
        }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        print("Widget: placeholder called")
        return SimpleEntry(
            date: Date(),
            verse: BibleVerse(
                verse: "Loading...",
                reference: "Please wait"
            ),
            isPlaceholder: true,
            errorMessage: nil
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        print("Widget: getSnapshot called")
        let entry = getCurrentEntry(isSnapshot: true)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("Widget: getTimeline called")
        let entry = getCurrentEntry(isSnapshot: false)
        
        // Schedule updates more frequently
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Create an update every 30 seconds for testing
        var entries: [SimpleEntry] = []
        for secondOffset in stride(from: 0, through: 300, by: 30) {
            let entryDate = calendar.date(byAdding: .second, value: secondOffset, to: currentDate)!
            entries.append(SimpleEntry(
                date: entryDate,
                verse: entry.verse,
                isPlaceholder: false,
                errorMessage: entry.errorMessage
            ))
        }
        
        print("Widget: Created timeline with \(entries.count) entries")
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func getCurrentEntry(isSnapshot: Bool) -> SimpleEntry {
        print("\n=== Widget Data Fetch Start ===")
        print("Context: \(isSnapshot ? "Snapshot" : "Timeline")")
        
        // First check if we can access the app group container
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            print("Error: Cannot access app group container")
            return SimpleEntry(
                date: Date(),
                verse: BibleVerse(verse: "Error", reference: "Configuration Error"),
                isPlaceholder: false,
                errorMessage: "Cannot access app group. Please check entitlements."
            )
        }
        
        guard let defaults = userDefaults else {
            print("Error: Cannot initialize UserDefaults")
            return SimpleEntry(
                date: Date(),
                verse: BibleVerse(verse: "Error", reference: "Configuration Error"),
                isPlaceholder: false,
                errorMessage: "Cannot access UserDefaults. Please check configuration."
            )
        }
        
        // Print all keys in UserDefaults
        print("All UserDefaults keys:")
        let allKeys = defaults.dictionaryRepresentation().keys
        print("Available keys: \(allKeys.joined(separator: ", "))")
        
        let verse = defaults.string(forKey: "verse")
        let reference = defaults.string(forKey: "reference")
        
        print("\nFound values:")
        print("verse: \(verse ?? "nil")")
        print("reference: \(reference ?? "nil")")
        
        if let verse = verse, let reference = reference, !verse.isEmpty, !reference.isEmpty {
            print("Using stored values for widget")
            return SimpleEntry(
                date: Date(),
                verse: BibleVerse(verse: verse, reference: reference),
                isPlaceholder: false,
                errorMessage: nil
            )
        } else {
            print("No valid stored values found")
            return SimpleEntry(
                date: Date(),
                verse: BibleVerse(verse: "No verse available", reference: "Error"),
                isPlaceholder: false,
                errorMessage: "No data found in UserDefaults"
            )
        }
    }
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
    let isPlaceholder: Bool
    let errorMessage: String?
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
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            Color(UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1.0))
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("DAILY VERSE")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.7))
                        .textCase(.uppercase)
                    
                    if entry.isPlaceholder {
                        Text("(Loading...)")
                            .font(.system(size: 11))
                            .foregroundColor(Color.white.opacity(0.5))
                    }
                }
                
                if let error = entry.errorMessage {
                    Text(error)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                } else {
                    Text("\"\(entry.verse.verse)\"")
                        .font(.system(size: 16, weight: .regular, design: .serif))
                        .foregroundColor(.white)
                        .lineLimit(family == .systemSmall ? 4 : 8)
                        .lineSpacing(1)
                        .minimumScaleFactor(0.8)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer(minLength: 4)
                
                Text(entry.verse.reference)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(Color.white.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(12)
            .opacity(entry.isPlaceholder ? 0.7 : 1.0)
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
        .description("Display today's Bible verse.")
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
    ), isPlaceholder: false, errorMessage: nil)
}

// Model for API response
struct BibleAPIVerse: Codable {
    let text: String
    let bookname: String
    let chapter: String
    let verse: String
}