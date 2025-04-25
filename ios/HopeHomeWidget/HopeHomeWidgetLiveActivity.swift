//
//  HopeHomeWidgetLiveActivity.swift
//  HopeHomeWidget
//
//  Created by Ariful Wadud on 13/4/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct HopeHomeWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct HopeHomeWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HopeHomeWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension HopeHomeWidgetAttributes {
    fileprivate static var preview: HopeHomeWidgetAttributes {
        HopeHomeWidgetAttributes(name: "World")
    }
}

extension HopeHomeWidgetAttributes.ContentState {
    fileprivate static var smiley: HopeHomeWidgetAttributes.ContentState {
        HopeHomeWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: HopeHomeWidgetAttributes.ContentState {
         HopeHomeWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: HopeHomeWidgetAttributes.preview) {
   HopeHomeWidgetLiveActivity()
} contentStates: {
    HopeHomeWidgetAttributes.ContentState.smiley
    HopeHomeWidgetAttributes.ContentState.starEyes
}
