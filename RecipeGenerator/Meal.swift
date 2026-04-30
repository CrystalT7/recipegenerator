//
//  Meal.swift
//  RecipeGenerator
//
//  Created by Student on 4/30/26.
//

import Foundation
struct Meal: Codable, Identifiable {
    let id: String
    let name: String
    let instructions: String
    let thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case thumbnail = "strMealThumb"
    }
    
    

}
