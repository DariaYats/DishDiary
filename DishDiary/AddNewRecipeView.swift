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
    @State private var portions = ""
    @State private var ingredients: [String] = []
    @State private var newIngredient = ""
    @State private var steps: [String] = []
    @State private var link = ""
    @State private var cookingTime = ""

    @State private var selectedImage: UIImage?
    @State private var imageName: String?
    @State private var isPhotoPickerPresented = false
  
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Recipe details")) {
                    TextField("Name", text: $name)
                    TextField("Portions", text: $portions)
                }

                Section(header: Text("Cooking time")) {
                    TextField("Cooking time in minutes", text: $cookingTime)
                }

                Section(header: Text("Ingredients")) {
                    HStack {
                        TextField("Add ingredient", text: $newIngredient)
                        Button(action: {
                            if !newIngredient.isEmpty {
                                ingredients.append(newIngredient)
                                newIngredient = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(newIngredient.isEmpty)
                    }
                    ForEach(ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                    }
                    .onDelete { indices in
                        ingredients.remove(atOffsets: indices)
                    }
                }

                Section(header: Text("Photo")) {
                    Button(action: {
                        isPhotoPickerPresented = true
                    }) {
                        HStack {
                            Text("Add Photo")
                            Image(systemName: "photo")
                        }
                    }

                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveRecipe()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .sheet(isPresented: $isPhotoPickerPresented) {
                PhotoPickerView { image in
                    if let image {
                        selectedImage = image
                        imageName = saveImage(image: image)
                    }
                    isPhotoPickerPresented = false
                }
            }
        }
    }


    func saveRecipe() {
        guard !name.isEmpty else { return }
        let newRecipe = Recipe(
            name: name,
            portions: portions,
            ingredients: ingredients,
            steps: steps,
            link: link,
            cookingTime: cookingTime,
            imageName: imageName ?? ""
            )


        modelContext.insert(newRecipe)
        try? modelContext.save()
        dismiss()
    }

    func saveImage(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return nil }
        let fileName = UUID().uuidString + ".jpg"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        do {
            try imageData.write(to: fileURL)
            return fileName
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
}

#Preview {
    AddNewRecipeView()
        .modelContainer(for: Recipe.self)
}
