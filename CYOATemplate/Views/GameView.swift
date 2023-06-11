//
//  GameView.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2023-05-29.
//

import Blackbird
import RetroText
import SwiftUI

struct GameView: View {
    
    // MARK: Stored properties
    @State var currentNodeId: Int = 1
    
    @Binding var retroGameFontActive: Bool
    
    @State private var showingPopover = false
    
    @State var previousNodes: [Int] = [1]
    
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS VisitedNodeCount FROM Node WHERE Node.visits > 0")
    }) var nodesVisitedStats
    
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS TotalNodeCount FROM Node")
    }) var totalNodesStats
    
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS EndingsVisitedCount FROM Node WHERE ending_type_id IS NOT NULL AND Node.visits > 0 ")
    }) var endingsVisitedStats
    
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS TotalEndingCount FROM Node WHERE ending_type_id IS NOT NULL")
    }) var totalEndingsStats
    
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT SUM(visits) AS DeathCount FROM Node WHERE ending_type_id > 3")
    }) var timesDiedStats
    
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT SUM(visits) AS FinishedCount FROM Node WHERE ending_type_id IS NOT NULL")
    }) var timesFinishedStats
    
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS TotalEndingsCount FROM Node GROUP BY ending_type_id")
    }) var totalEndingsTypeStats
    
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT SUM(visits) AS VisitedEndingCount FROM Node GROUP BY ending_type_id")
    }) var timesEndingVisitedStats
    
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS EndingsVisitedCount FROM Node WHERE ending_type_id = 1")
    }) var endingsVisitedType1Stats
    
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS EndingsVisitedCount FROM Node WHERE ending_type_id = 2")
    }) var endingsVisitedType2Stats
    
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS EndingsVisitedCount FROM Node WHERE ending_type_id = 3")
    }) var endingsVisitedType3Stats
    
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS EndingsVisitedCount FROM Node WHERE ending_type_id = 4")
    }) var endingsVisitedType4Stats
    
    @BlackbirdLiveQuery(tableName: "Node", { db in
        try await db.query("SELECT COUNT(*) AS EndingsVisitedCount FROM Node WHERE ending_type_id = 5")
    }) var endingsVisitedType5Stats
    
    var visitedNodes: Int {
        return nodesVisitedStats.results.first?["VisitedNodeCount"]?.intValue ?? 0
    }
    
    var totalNodes: Int {
        return totalNodesStats.results.first?["TotalNodeCount"]?.intValue ?? 0
    }
    
    var visitedEndings: Int {
        return endingsVisitedStats.results.first?["EndingsVisitedCount"]?.intValue ?? 0
    }
    
    var totalEndings: Int {
        return totalEndingsStats.results.first?["TotalEndingCount"]?.intValue ?? 0
    }
    
    var totalDeaths: Int {
        return timesDiedStats.results.first?["DeathCount"]?.intValue ?? 0
    }
    
    var totalFinishes: Int {
        return timesFinishedStats.results.first?["FinishedCount"]?.intValue ?? 0
    }
    
    var totalEndingsType: [Int] {
        var ar = [0]
        if totalEndingsTypeStats.results.count < 2 {
            return [0, 20, 20, 20, 20, 20]
        }
        for i in 1..<totalEndingsTypeStats.results.count {
            ar.append(totalEndingsTypeStats.results[i]["TotalEndingsCount"]?.intValue ?? 0)
        }
        return ar
    }
    
    var timesEndingVisited: [Int] {
        var ar = [0]
        if timesEndingVisitedStats.results.count < 2 {
            return [0, 20, 20, 20, 20, 20]
        }
        for i in 1..<timesEndingVisitedStats.results.count {
            ar.append(timesEndingVisitedStats.results[i]["VisitedEndingCount"]?.intValue ?? 0)
        }
        return ar
    }
    
    var endingsVisitedType: [Int] {
        var ar = [0]
        ar.append(endingsVisitedType1Stats.results.first?["TotalEndingsCount"]?.intValue ?? 0)
        ar.append(endingsVisitedType2Stats.results.first?["TotalEndingsCount"]?.intValue ?? 0)
        ar.append(endingsVisitedType3Stats.results.first?["TotalEndingsCount"]?.intValue ?? 0)
        ar.append(endingsVisitedType4Stats.results.first?["TotalEndingsCount"]?.intValue ?? 0)
        ar.append(endingsVisitedType5Stats.results.first?["TotalEndingsCount"]?.intValue ?? 0)
        return ar
    }
    
    // MARK: Computed properties
    var body: some View {
        
        ZStack {
            if retroGameFontActive == true {
                Color(.systemCyan)
                    .ignoresSafeArea()
            } else {
                Color(.systemYellow)
                    .ignoresSafeArea()
            }
            
            VStack {
                HStack {
                    ZStack {
                        Text("Back")
                            .retroFont(.pixelEmulator, size: 14)
                            .foregroundColor(.white)
                            .opacity(retroGameFontActive ? 1 : 0)
                        Text("Back")
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .foregroundColor(.white)
                            .opacity(retroGameFontActive ? 0 : 1)
                    }
                    .opacity(previousNodes.count > 1 ? 1 : 0)
                    .onTapGesture {
                        previousNodes.popLast()
                        currentNodeId = previousNodes.last!
                    }
                    Spacer()
                }
                .padding()
                HStack {
                    
                    if retroGameFontActive == true {
                        Text("\(currentNodeId)")
                            .retroFont()
                            .padding(.leading)
                    } else {
                        Text("\(currentNodeId)")
                            .font(.system(size: 35, weight: .medium, design: .monospaced))
                            .padding(.leading)
                    }
                    
                    Spacer()
                    
                    Label(title: {
                        Text("")
                        //                        Text("Settings")
                        
                    }, icon: {
                        Image(systemName: "gearshape.2")
                        
                    })
                    .padding(.trailing)
                    .onTapGesture {
                        showingPopover = true
                    }
                    .popover(isPresented: $showingPopover) {
                        VStack(spacing: 20) {
                            HStack {
                                
                                VStack {
                                    HStack {
                                        Text("Retro Mode")
                                            .padding()
                                        Toggle("", isOn: $retroGameFontActive)
                                            .padding()
                                    }
                                    Spacer()
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Button(action: {
                                        showingPopover = false
                                    }, label: {
                                        Label(title: {
                                            Text("Back")
                                        }, icon: {
                                            Image(systemName: "arrowshape.turn.up.backward")
                                        })
                                        .foregroundColor(.blue)
                                        .padding()
                                    })
                                    
                                    Spacer()
                                    
                                }
                                
                            }
                                                        
                            HStack {
                                Text("You have read \(visitedNodes) pages out of \(totalNodes).")
                                ProgressView(value: Double(visitedNodes), total: Double(totalNodes))
                            }
                            HStack {
                                Text("You have reached \(visitedEndings) endings out of \(totalEndings).")
                                ProgressView(value: Double(visitedEndings), total: Double(totalEndings))
                            }
                            HStack {
                                Text("You died \(totalDeaths) times out of the \(totalFinishes) times you finished the story.")
                                ProgressView(value: Double(totalDeaths), total: Double(totalFinishes))
                            }
                            .opacity(totalFinishes > 0 ? 1 : 0)
                            ForEach(1..<6) { i in
                                Text("You reached a \(endingTypes[i]) ending a total of \(timesEndingVisited[i]) times.")
                            }
                            ForEach(1..<6) { i in
                                HStack {
                                    Text("You have reached \(endingsVisitedType[i]) \(endingTypes[i]) endings out of \(totalEndingsType[i]).")
                                    ProgressView(value: Double(endingsVisitedType[i]), total: Double(totalEndingsType[i]))
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                if retroGameFontActive == true {
                    NodeView(currentNodeId: currentNodeId, retroGameFontActive: retroGameFontActive)
                        .retroFont(.pixelEmulator, size: 14)
                        .padding(.horizontal)
                } else {
                    NodeView(currentNodeId: currentNodeId, retroGameFontActive: retroGameFontActive)
                        .padding(.horizontal)
                }
                
                Divider()
                
                EdgesView(currentNodeId: $currentNodeId, retroGameFontActive: retroGameFontActive)
                    .padding(.trailing)
                
                Spacer()
                
            }
            .opacity(currentNodeId < 55 || currentNodeId > 60 ? 1 : 0)
            VStack {
                HStack {
                    ZStack {
                        Text("Back")
                            .retroFont(.pixelEmulator, size: 14)
                            .foregroundColor(.white)
                            .opacity(retroGameFontActive ? 1 : 0)
                        Text("Back")
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .foregroundColor(.white)
                            .opacity(retroGameFontActive ? 0 : 1)
                    }
                    .opacity(previousNodes.count > 1 ? 1 : 0)
                    .onTapGesture {
                        previousNodes.popLast()
                        currentNodeId = previousNodes.last!
                    }
                    Spacer()
                }
                .padding()
                Spacer()
                SpinnerView(currentNodeId: $currentNodeId)
                Spacer()
            }
            .opacity(currentNodeId < 55 || currentNodeId > 60 ? 0 : 1)
        }
        .onChange(of: currentNodeId) { newNodeId in
            if newNodeId != previousNodes.last {
                previousNodes.append(newNodeId)
            }
        }
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(retroGameFontActive: .constant(false))
        // Make the database available to all other view through the environment
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}

