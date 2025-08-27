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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss

    var body: some View {
           ScrollView {
               if let image = UIImage.fromDocuments(named: recipe.imageName) {
                   Image(uiImage: image)
                       .resizable()
                       .scaledToFill()
               } else {
                   ZStack {
                       RoundedRectangle(cornerRadius: 12)
                           .fill(Color(.systemGray6))

                       Image(systemName: "fork.knife.circle.fill")
                           .font(.system(size: 28))
                           .foregroundColor(.secondary)
                   }
                   .frame(width: 60, height: 60)
               }

               Text(recipe.name)
                   .font(.largeTitle.bold())
                   .foregroundColor(.primary)
                   .padding(.horizontal)

               HStack(spacing: 40) {
                   TimeCircle(label: "Servings", time: recipe.servings)
                   TimeCircle(label: "Minutes", time: String(recipe.cookingTime))
               }
               .padding(.vertical)

               Divider()
                   .padding(.horizontal)

               VStack(alignment: .leading, spacing: 12) {
                   Text("Ingredients")
                       .font(.headline)
                       .foregroundColor(.primary)

                   ForEach(recipe.ingredients, id: \.self) { ingredient in
                       HStack(alignment: .top, spacing: 8) {
                           Image(systemName: "checkmark.circle.fill")
                               .foregroundColor(.accentColor)
                           Text(ingredient)
                               .font(.body)
                               .foregroundColor(.secondary)
                       }
                       Divider()
                   }
               }
               .padding()

               VStack(alignment: .leading, spacing: 12) {
                   Text("Steps")
                       .font(.headline)
                       .foregroundColor(.primary)

                   ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                       HStack(alignment: .top, spacing: 8) {
                           Text("\(index + 1).")
                               .font(.subheadline.bold())
                               .foregroundColor(.accentColor)

                           Text(step)
                               .font(.body)
                               .foregroundColor(.secondary)
                               .multilineTextAlignment(.leading)
                       }
                       Divider()
                   }
               }
               .padding()

               if let url = URL(string: recipe.link), !recipe.link.isEmpty {
                   Link(destination: url) {
                       Label("View More", systemImage: "link.circle.fill")
                           .font(.headline)
                           .foregroundColor(.white)
                           .padding()
                           .frame(maxWidth: .infinity)
                           .background(Color.accentColor)
                           .cornerRadius(12)
                           .shadow(radius: 2)
                   }
                   .padding(.horizontal)
                   .padding(.bottom, 30)
               }
           }
           .ignoresSafeArea(edges: [.top])
           .background(Color(.systemBackground))
           .navigationBarTitleDisplayMode(.inline)
    }
}


   struct TimeCircle: View {
       let label: String
       let time: String

       var body: some View {
           VStack {
               ZStack {
                   Circle()
                       .fill(Color(.systemGray6))
                       .frame(width: 70, height: 70)
                       .shadow(radius: 1)

                   Text(time)
                       .font(.headline)
                       .foregroundColor(.primary)
               }
               Text(label)
                   .font(.caption)
                   .foregroundColor(.secondary)
           }
       }
   }

   #Preview {
       let config = ModelConfiguration(isStoredInMemoryOnly: true)
       let container = try! ModelContainer(for: Recipe.self, configurations: config)

       let sampleRecipe = Recipe(
           name: "Pizza",
           servings: "2",
           ingredients: ["200 g of flour", "300 g cheese"],
           steps: ["Make dough", "Add pizza sauce", "Bake until golden"],
           link: "youtube.com",
           cookingTime: 45,
           imageName: "pizza"
       )

       container.mainContext.insert(sampleRecipe)

       return NavigationStack {
           DetailView(recipe: sampleRecipe)
               .modelContainer(container)
       }
   }
