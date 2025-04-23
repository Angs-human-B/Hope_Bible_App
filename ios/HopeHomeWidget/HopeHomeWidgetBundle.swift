//
//  HopeHomeWidgetBundle.swift
//  HopeHomeWidget
//
//  Created by Ariful Wadud on 13/4/25.
//

import WidgetKit
import SwiftUI

@main
struct HopeHomeWidgetBundle: WidgetBundle {
    var body: some Widget {
        HopeHomeWidget()
        HopeHomeWidgetControl()
        HopeHomeWidgetLiveActivity()
    }
}
