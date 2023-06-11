//
//  EdgesView.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2023-06-01.
//

import Blackbird
import SwiftUI
import RetroText
import UIKit

struct EdgesView: View {
    
    // MARK: Stored properties
    
    // Needed to query database
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    let retroGameFontActive: Bool
    
    // The list of edges retrieved
    @BlackbirdLiveModels var edges: Blackbird.LiveResults<Edge>
    
    // The current node that edges are being shown for.
    //
    // NOTE: This is a derived value; it points at the source of
    // truth for the current node on GameView. This allows the current
    // node to be changed from this view.
    @Binding var currentNodeId: Int
    
    // MARK: Computed properties
    
    // The user interface
    var body: some View {
        
        VStack(spacing: 20) {
            
            if edges.results.count > 0 {
                
                ForEach(edges.results) { currentEdge in
                    
                    HStack {
                        
                        Spacer()
                        
                        // Show a Text view, but render Markdown syntax, ignoring newlines
                        if retroGameFontActive == true {
                            Text(try! AttributedString(markdown: currentEdge.prompt))
                                .multilineTextAlignment(.trailing)
                                .onTapGesture {
                                    currentNodeId = currentEdge.to_node_id
                                }
                                .retroFont(.pixelEmulator, size: 14)
                                .foregroundColor(.white)
                        } else {
                            Text(try! AttributedString(markdown: currentEdge.prompt))
                                .multilineTextAlignment(.trailing)
                                .onTapGesture {
                                    currentNodeId = currentEdge.to_node_id
                                }
                                .font(.system(size: 16, weight: .medium, design: .monospaced))
                        }
                        
                        
                    }
                    
                }
                
            } else {
                HStack {
                    Spacer()
                    
                    if retroGameFontActive == true {
                        Text("This marks the end of the story. Return to start.")
                            .onTapGesture {
                                currentNodeId = 1
                            }
                            .retroFont(.pixelEmulator, size: 14)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.trailing)
                    }
                    else {
                        Text("This marks the end of the story. Return to start.")
                            .onTapGesture {
                                currentNodeId = 1
                            }
                            .multilineTextAlignment(.trailing)
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                    }
                }
            }
            
        }
        
    }
    
    // MARK: Initializer
    init(currentNodeId: Binding<Int>, retroGameFontActive: Bool) {
        
        // Retrieve edges for the current node in the graph
        _edges = BlackbirdLiveModels({ db in
            try await Edge.read(from: db,
                                sqlWhere: "from_node_id = ?", "\(currentNodeId.wrappedValue)")
        })
        
        // Set the current node
        _currentNodeId = currentNodeId
        
        self.retroGameFontActive = retroGameFontActive
    }
}
struct EdgesView_Previews: PreviewProvider {
    static var previews: some View {
        
        EdgesView(currentNodeId: .constant(3), retroGameFontActive: false)
        // Make the database available to all other view through the environment
            .environment(\.blackbirdDatabase, AppDatabase.instance)
        
    }
}
