//
//  NodeView.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2023-06-01.
//

import Blackbird
import SwiftUI

struct NodeView: View {
    
    // MARK: Stored properties
    
    // The id of the node we are trying to view
    let currentNodeId: Int
    
    // How many nodes have been visited?
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS VistedNodeCount FROM Node WHERE Node.visits > 0")
    }) var nodesVisitedStats
    
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS TotalNodeCount FROM Node")
    }) var totalNodesStats
    
    // The actual integer value for how many nodes have been visited
    var visitedNodes: Int {
        return nodesVisitedStats.results.first?["VisitedNodeCount"]?.intValue ?? 0
    }
    
    var totalNodes: Int {
        return totalNodesStats.results.first?["TotalNodeCount"]?.intValue ?? 0
    }

    // Needed to query database
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    // The list of nodes retrieved
    @BlackbirdLiveModels var nodes: Blackbird.LiveResults<Node>
    
    // MARK: Computed properties
    
    // The user interface
    var body: some View {
        if let node = nodes.results.first {
            
            VStack(spacing: 10) {
                
                Text("A total of \(visitedNodes) nodes out of \(totalNodes) nodes overall have beben visited in this story.")
                
                Divider()
            
                Text("Node visited \(node.visits) times")
                
                Divider()
                
                // Show a Text view, but render Markdown syntax, preserving newline characters
                Text(try! AttributedString(markdown: node.narrative,
                                           options: AttributedString.MarkdownParsingOptions(interpretedSyntax:
                                                .inlineOnlyPreservingWhitespace)))
                .onAppear {
                    // Update visits count for this node
                    Task {
                        try await db!.transaction { core in
                            try core.query("UPDATE Node SET visits = Node.visits + 1 WHERE node_id = ?", currentNodeId)
                        }
                    }
                }
            }
        } else {
            Text("Node with id \(currentNodeId) not found; directed graph has a gap.")
        }
    }
    
    // MARK: Initializer
    init(currentNodeId: Int) {
        
        // Retrieve rows that describe nodes in the directed graph
        // NOTE: There should only be one row for a given node_id
        //       since there is a UNIQUE constrant on the node_id column
        //       in the Node table
        _nodes = BlackbirdLiveModels({ db in
            try await Node.read(from: db,
                                    sqlWhere: "node_id = ?", "\(currentNodeId)")
        })
        
        // Set the node we are trying to view
        self.currentNodeId = currentNodeId
        
    }

    
}

struct NodeView_Previews: PreviewProvider {
    
    static var previews: some View {

        NodeView(currentNodeId: 1)
        // Make the database available to all other view through the environment
        .environment(\.blackbirdDatabase, AppDatabase.instance)

    }
}
