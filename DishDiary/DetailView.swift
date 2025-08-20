//
//  DetailView.swift
//  DishDiary
//
//  Created by Daria Yatsyniuk on 12.08.2025.
//
import SwiftData
import SwiftUI

struct DetailView: View {
    let recipe: Recipe
    @Environment(\.modelContext) var modelContext

    var body: some View {
        NavigationStack {
            List { 

            }
        }
    }
}

#Preview {
    DetailView(recipe: Recipe(name: "Example", content: "you need something", link: "youtube", cookingTime: "30 min", imageName: "example"))
}
