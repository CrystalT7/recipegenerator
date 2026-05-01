//
//  ContentView.swift
//  RecipeGenerator
//
//  Created by Student on 4/29/26.
//

import SwiftUI


struct ContentView: View {
    @State private var mealOne: Meal?
    @State private var mealTwo: Meal?
    @State private var mealThree: Meal?
    @State private var mealFour: Meal?
    

    let imageSize: CGFloat = 100

    var body: some View {
        VStack(spacing: 20) {
            Text("The Recipe Generator")
                .font(.custom("Marseille Free", size: 40))
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
                     
                        mealOne = try await fetchRandomMeal()
                        mealTwo = try await fetchRandomMeal()
                        mealThree = try await fetchRandomMeal()
                        mealFour = try await fetchRandomMeal()
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
 
    @ViewBuilder
    private func mealImageView(for meal: Meal?) -> some View {
        if let meal = meal, let url = URL(string: meal.thumbnail) {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .aspectRatio(contentMode: .fill) 
            .frame(width: imageSize, height: imageSize)
            .cornerRadius(10)
            .clipped()
        } else {
       
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: imageSize, height: imageSize)
                .cornerRadius(10)
        }
    }
}


import UIKit

func fetchRandomMeal() async throws -> Meal? {
    let urlString = "https://www.themealdb.com/api/json/v1/1/random.php"
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
 
    let (data, _) = try await URLSession.shared.data(from: url)
    

    let decodedResponse = try JSONDecoder().decode(MealResponse.self, from: data)
    

    return decodedResponse.meals.first
}

#Preview {
    ContentView()
}
