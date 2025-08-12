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
    var name: String
    var content: String
    var link: String
    var cookingTime: String
    var imageName: String

    init(name: String, content: String, link: String, cookingTime: String, imageName: String) {
        self.name = name
        self.content = content
        self.link = link
        self.cookingTime = cookingTime
        self.imageName = imageName
    }
}
