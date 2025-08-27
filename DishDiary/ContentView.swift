//
//  ContentView.swift
//  DishDiary
//
//  Created by Daria Yatsyniuk on 11.08.2025.
//
import SwiftData
import SwiftUI

struct ContentView: View {
    @Query private var recipes: [Recipe]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            Group {
                if recipes.isEmpty {
                    ContentUnavailableView(
                        "No Recipes Yet",
                        systemImage: "book.closed",
                        description: Text("Tap the plus button to add your first recipe.")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(recipes) { recipe in
                                NavigationLink {
                                    DetailView(recipe: recipe)
                                } label: {
                                    RecipeCard(recipe: recipe)
                                }
                                .buttonStyle(.plain)
                            }
                            .onDelete(perform: deleteRecipe)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddNewRecipeView()
                    } label: {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                }
            }
        }
    }

    private func deleteRecipe(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(recipes[index])
        }
    }
}

#Preview {
    ContentView()
}


struct RecipeCard: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: 16) {
            if let image = UIImage.fromDocuments(named: recipe.imageName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray5))
                    Image(systemName: "fork.knife.circle")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .frame(width: 70, height: 70)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                HStack(spacing: 12) {
                    if !recipe.servings.isEmpty {
                        Label(recipe.servings, systemImage: "person.2.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Label("\(recipe.cookingTime) min", systemImage: "clock.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

