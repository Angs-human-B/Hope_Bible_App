//
//  HopeHomeWidgetBundle.swift
//  HopeHomeWidget
//
//  Created by Ariful Wadud on 27/4/25.
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
