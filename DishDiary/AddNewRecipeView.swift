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
    @State private var servings = ""
    @State private var ingredients: [String] = []
    @State private var newIngredient = ""
    @State private var steps: [String] = []
    @State private var newStep = ""
    @State private var link = ""
    @State private var cookingTime = 5

    @State private var selectedImage: UIImage?
    @State private var imageName: String?
    @State private var isPhotoPickerPresented = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Recipe Info") {
                    TextField("Name", text: $name)
                        .textInputAutocapitalization(.words)
                    TextField("Servings (e.g. 2–4)", text: $servings)
                        .keyboardType(.numbersAndPunctuation)
                    Picker("Cooking Time", selection: $cookingTime) {
                        ForEach(5...240, id: \.self) { time in
                            Text("\(time) min")
                        }
                    }
                }

                Section("Ingredients") {
                    HStack {
                        TextField("Add ingredient", text: $newIngredient)
                            .onSubmit(addIngredient)
                        Button {
                            addIngredient()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.accentColor)
                        }
                        .disabled(newIngredient.isEmpty)
                    }

                    if ingredients.isEmpty {
                        Text("No ingredients added yet")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(ingredients, id: \.self) { ingredient in
                            Text(ingredient)
                        }
                        .onDelete { indices in
                            ingredients.remove(atOffsets: indices)
                        }
                    }
                }

                Section("Steps") {
                    HStack {
                        TextField("Add step", text: $newStep)
                            .onSubmit(addStep)
                        Button {
                            addStep()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.accentColor)
                        }
                        .disabled(newStep.isEmpty)
                    }

                    if steps.isEmpty {
                        Text("No steps added yet")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(steps, id: \.self) { step in
                            Text(step)
                        }
                        .onDelete { indices in
                            steps.remove(atOffsets: indices)
                        }
                    }
                }

                Section("Photo") {
                    Button {
                        isPhotoPickerPresented = true
                    } label: {
                        Label("Choose Photo", systemImage: "photo.on.rectangle")
                    }

                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 2)
                    }
                }

                Section("Link (optional)") {
                    TextField("https://example.com", text: $link)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
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

    private func addIngredient() {
        guard !newIngredient.isEmpty else { return }
        ingredients.append(newIngredient)
        newIngredient = ""
    }

    private func addStep() {
        guard !newStep.isEmpty else { return }
        steps.append(newStep)
        newStep = ""
    }

    private func saveRecipe() {
        guard !name.isEmpty else { return }
        let newRecipe = Recipe(
            name: name,
            servings: servings,
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

    private func saveImage(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else { return nil }
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

