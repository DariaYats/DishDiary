//
//  AddNewRecipe.swift
//  DishDiary
//
//  Created by Daria Yatsyniuk on 18.08.2025.
//

import SwiftData
import SwiftUI

struct AddNewRecipeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var descriprion = ""
    @State private var cookingTime = ""
    // cooking time as a picker?
    // ingregients list?

    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Description", text: $descriprion)
                .frame(width: 200, height: 100)
        }

        HStack {
            Button("Save") {
                saveRecipe()
            }
        }
    }

    func saveRecipe() {
        guard !name.isEmpty else { return }
        let newRecipe = Recipe(name: name, content: descriprion, link: "", cookingTime: cookingTime, imageName: "")
        modelContext.insert(newRecipe)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    AddNewRecipeView()
}
