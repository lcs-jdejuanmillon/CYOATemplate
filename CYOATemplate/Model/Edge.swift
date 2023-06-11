//
//  Edge.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2023-05-29.
//

import Blackbird
import Foundation

struct Edge: BlackbirdModel {
    
    @BlackbirdColumn var id: Int
    @BlackbirdColumn var from_node_id: Int
    @BlackbirdColumn var to_node_id: Int
    @BlackbirdColumn var prompt: String
    
}
