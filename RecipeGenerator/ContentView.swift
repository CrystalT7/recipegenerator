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
    
    var body: some View {
        

            
        VStack {
            Text("The Recipe Generator")
                .font(.custom("Marseille Free", size: 50))
            
            HStack{
                
                if let mealOne = mealOne {
                    Text(mealOne.name).font(.custom("Marseille Free", size: 0))
                        .hidden()
                    AsyncImage(url: URL(string: mealOne.thumbnail)){ image in
                        image
                            .image?.resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    .frame(width: 100, height: 100)
                }
                if let mealTwo = mealTwo {
                    Text(mealTwo.name).font(.custom("Marseille Free", size: 0))
                        .hidden()
                    AsyncImage(url: URL(string: mealTwo.thumbnail)){ image in
                        image
                            .image?.resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: 100, height: 100)
                    
                    
                    
                }
            }
            
            HStack{
                
                if let mealThree = mealThree {
                    Text(mealThree.name).font(.custom("Marseille Free", size: 0))
                        .hidden()
                    AsyncImage(url: URL(string: mealThree.thumbnail)){ image in
                        image
                            .image?.resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: 100, height: 100)
                }
                
                if let mealFour = mealFour {
                    Text(mealFour.name).font(.custom("Marseille Free", size: 0))
                        .hidden()
                    AsyncImage(url: URL(string: mealFour.thumbnail)){ image in
                        image
                            .image?.resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: 100, height: 100)
                }
            }
            
            Button("Generate Random Meals"){
                Task{
                    do{
                        mealOne = try await fetchRandomMeal()
                        mealTwo = try await fetchRandomMeal()
                        mealThree = try await fetchRandomMeal()
                        mealFour = try await fetchRandomMeal()
                        
                    } catch {
                        print("error")
                    }
                }
            }
        }
        .padding()
    }
}

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
