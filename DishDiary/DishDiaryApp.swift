//
//  DishDiaryApp.swift
//  DishDiary
//
//  Created by Daria Yatsyniuk on 11.08.2025.
//
import SwiftData
import SwiftUI

@main
struct DishDiaryApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Recipe.self)
    }
}
