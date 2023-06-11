//
//  Ending.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2023-05-29.
//

import Blackbird
import Foundation

struct EndingType: BlackbirdModel {
    @BlackbirdColumn var id: Int
    @BlackbirdColumn var type: String
    @BlackbirdColumn var color: String
}

let endingTypes = ["", "Outstanding", "Favorable", "Mediocre", "Bad", "Catastrophic"]
