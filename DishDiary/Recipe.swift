//
//  Recipe.swift
//  DishDiary
//
//  Created by Daria Yatsyniuk on 11.08.2025.
//
import SwiftData
import Foundation

@Model
class Recipe {
    var id = UUID()
    var name: String
    var portions: String
    var ingredients: [String] = []
    var steps: [String] 
    var link: String
    var cookingTime: Int
    var imageName: String

    init(name: String, portions: String, ingredients: [String] = [], steps: [String], link: String, cookingTime: Int, imageName: String) {
        self.name = name
        self.portions = portions
        self.ingredients = ingredients
        self.steps = steps
        self.link = link
        self.cookingTime = cookingTime
        self.imageName = imageName
    }


}
