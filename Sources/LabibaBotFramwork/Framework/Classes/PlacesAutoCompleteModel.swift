//
//  PlacesAutoCompleteModel.swift
//  dubaiPolice
//
//  Created by Yehya Titi on 1/26/19.
//  Copyright © 2019 ahmed. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let placesAutoCompleteModel = try? newJSONDecoder().decode(PlacesAutoCompleteModel.self, from: jsonData)

import Foundation

struct PlacesAutoCompleteModel: Codable
{
    let predictions: [Prediction]
    let status: String
}

struct Prediction: Codable
{
    let description, id: String
    let matchedSubstrings: [MatchedSubstring]
    let placeID, reference: String
    let structuredFormatting: StructuredFormatting
    let terms: [Term]
    let types: [String]

    enum CodingKeys: String, CodingKey
    {
        case description, id
        case matchedSubstrings = "matched_substrings"
        case placeID = "place_id"
        case reference
        case structuredFormatting = "structured_formatting"
        case terms, types
    }
}

struct MatchedSubstring: Codable
{
    let length, offset: Int
}

struct StructuredFormatting: Codable
{
    let mainText: String
    let mainTextMatchedSubstrings: [MatchedSubstring]
    let secondaryText: String
    let secondaryTextMatchedSubstrings: [MatchedSubstring]

    enum CodingKeys: String, CodingKey
    {
        case mainText = "main_text"
        case mainTextMatchedSubstrings = "main_text_matched_substrings"
        case secondaryText = "secondary_text"
        case secondaryTextMatchedSubstrings = "secondary_text_matched_substrings"
    }
}

struct Term: Codable
{
    let offset: Int
    let value: String
}

