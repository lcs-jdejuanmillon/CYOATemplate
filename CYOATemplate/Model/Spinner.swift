//
//  Spinner.swift
//  CYOATemplate
//
//  Created by Jacobo de Juan Millon on 2023-06-07.
//
import Foundation
import Blackbird
struct Spinner: BlackbirdModel {
    
    @BlackbirdColumn var id: Int
    @BlackbirdColumn var visualPercentage1: Int
    @BlackbirdColumn var visualPercentage2: Int
    @BlackbirdColumn var actualPercentage1: Int
    @BlackbirdColumn var actualPercentage2: Int
    @BlackbirdColumn var color1: Int
    @BlackbirdColumn var color2: Int
    @BlackbirdColumn var color3: Int
    
}
