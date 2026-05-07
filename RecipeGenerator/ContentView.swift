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
    @State private var buttonEnabled = true
    @State private var selectedMeal: Meal?
    @State private var showSheet = false
    @State private var isScaled = false
    
    @State private var animatingMeal: Meal?
    let imageSize: CGFloat = 100

    var body: some View {
        
            VStack(spacing: 20) {
                Text("The Recipe Generator")
                    .font(.custom("Marseille Free", size: 60))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .lineLimit(nil)
                            .minimumScaleFactor(0.5)
                            .padding(.horizontal)
                
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
                
                Button("Press For Meals!!") {
                    Task {
                        do {
                           
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
                .buttonStyle(.glass)
              
                .disabled(!buttonEnabled)
            }
          
            .sheet(item: $selectedMeal) { meal in
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                  
                        if let url = URL(string: meal.thumbnail) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(12)
                        }
                        
                
                        Text(meal.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Divider()
                        
     
                        Text("Instructions")
                            .font(.headline)
                        
                   
                        Text(
                            meal.instructions
                                .replacingOccurrences(of: "\r\n", with: "\n")
                                .replacingOccurrences(of: "\n\n", with: "\n")
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        .font(.body)
                        .lineSpacing(6)
                    }
                    .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("WatercolorVeggie")
                    .resizable()
                    .scaledToFill()
            )
            .ignoresSafeArea()
       
       
    
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
            .onTapGesture {
                Task {
                    animatingMeal = meal
                    isScaled = true
                    
                    try? await Task.sleep(nanoseconds: 200_000_000) 
                    
                    isScaled = false
                    
                    try? await Task.sleep(nanoseconds: 200_000_000)
                    
                    selectedMeal = meal
                }
            }
            .scaleEffect(animatingMeal?.id == meal.id && isScaled ? 1.2 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isScaled)
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
