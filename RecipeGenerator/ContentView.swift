//
//  ContentView.swift
//  RecipeGenerator
//
//  Created by Student on 4/29/26.
//

import SwiftUI

// Assume Meal and MealResponse are defined elsewhere
struct ContentView: View {
    @State private var mealOne: Meal?
    @State private var mealTwo: Meal?
    @State private var mealThree: Meal?
    @State private var mealFour: Meal?
    @State private var buttonEnabled = true
    
    // Constant for image size to ensure stability
    let imageSize: CGFloat = 100

    var body: some View {
        VStack(spacing: 20) {
            Text("The Recipe Generator")
                .font(.custom("Marseille Free", size: 40)) // Adjusted size to fit
                .multilineTextAlignment(.center)
            
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    mealImageView(for: mealOne)
                    mealImageView(for: mealTwo)
                }
                
                HStack(spacing: 10) {
                    mealImageView(for: mealThree)
                    mealImageView(for: mealFour)
                }
            }
            
            Button("Generate Random Meals") {
                Task {
                    do {
                        // Fetching might still cause a slight flicker,
                        // consider adding a loading indicator inside mealImageView
                        buttonEnabled = false
                        mealOne = try await fetchRandomMeal()
                        mealTwo = try await fetchRandomMeal()
                        
                        if (mealOne?.name == mealTwo?.name){
                            mealTwo = try await fetchRandomMeal()
                        }
                        
                        mealThree = try await fetchRandomMeal()
                        if (mealThree?.name == mealTwo?.name){
                            mealThree = try await fetchRandomMeal()
                        }
                        mealFour = try await fetchRandomMeal()
                        
                        if (mealThree?.name == mealFour?.name){
                            mealFour = try await fetchRandomMeal()
                        }
                        
                        if (mealOne?.name == mealFour?.name){
                            mealOne = try await fetchRandomMeal()
                        }
                        
                        buttonEnabled = true
                        
                        
                        
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(!buttonEnabled)
        }
        .padding()
    }
    
    // Helper view to ensure consistent image layout
    @ViewBuilder
    private func mealImageView(for meal: Meal?) -> some View {
        if let meal = meal, let url = URL(string: meal.thumbnail) {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                ProgressView() // Shows loading indicator
            }
            .aspectRatio(contentMode: .fill) // Fill the frame
            .frame(width: imageSize, height: imageSize)
            .cornerRadius(10)
            .clipped() // Ensures image doesn't overflow
        } else {
            // Placeholder rectangle to keep the layout from jumping
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: imageSize, height: imageSize)
                .cornerRadius(10)
        }
    }
}

// Ensure your fetchRandomMeal function is properly handling empty states


import UIKit

func fetchRandomMeal() async throws -> Meal? {
    let urlString = "https://www.themealdb.com/api/json/v1/1/random.php"
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    // Fetch data using URLSession
    let (data, _) = try await URLSession.shared.data(from: url)
    
    // Decode the JSON response
    let decodedResponse = try JSONDecoder().decode(MealResponse.self, from: data)
    
    // Return the first meal in the array
    return decodedResponse.meals.first
}

#Preview {
    ContentView()
}
