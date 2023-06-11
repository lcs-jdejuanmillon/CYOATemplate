//
//  CYOATemplateApp.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2023-05-29.
//

import RetroText
import SwiftUI

@main
struct CYOATemplateApp: App {
    
    init() {
        RetroText.registerFonts()
    }
    
    @State var retroGameFont: Bool = false
    
    var body: some Scene {
        WindowGroup {
            TitlePageView(retroGameFontActive: $retroGameFont)
            // Make the database available to all other view through the environment
                .environment(\.blackbirdDatabase, AppDatabase.instance)
            
        }
    }
}

