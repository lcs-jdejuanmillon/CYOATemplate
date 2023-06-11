//
//  Node.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2023-05-29.
//

import Blackbird
import Foundation

struct Node: BlackbirdModel {
    
    @BlackbirdColumn var id: Int
    @BlackbirdColumn var node_id: Int
    @BlackbirdColumn var narrative: String
    @BlackbirdColumn var image: String?
    @BlackbirdColumn var ending_type_id: Int?
    @BlackbirdColumn var ending_narrative: String?
    @BlackbirdColumn var visits: Int
    
}
