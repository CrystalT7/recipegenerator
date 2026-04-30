//
//  Outline.swift
//  RecipeGenerator
//
//  Created by Student on 4/29/26.
//

import SwiftUI

struct Outline: View {
    var body: some View {
        
        VStack(spacing: 30) {
        Text("The Recipe Generator")
            .font(.custom("Marseille Free", size: 50))
        HStack(spacing: 40){
            Text("Recipe Photo 1")
                .font(.system(size:20))
                .frame(width: 90, height: 90)
                .background(Rectangle().fill(Color.blue))
            
            Text("Recipe Photo 1")
                .font(.system(size:20))
                .frame(width: 90, height: 90)
                .background(Rectangle().fill(Color.blue))
               
        }
        HStack(spacing: 40){
            Text("Recipe Photo 1")
                .font(.system(size:20))
                .frame(width: 90, height: 90)
                .background(Rectangle().fill(Color.blue))
            
            Text("Recipe Photo 1")
                .font(.system(size:20))
                .frame(width: 90, height: 90)
                .background(Rectangle().fill(Color.blue))
               
        }
    }
    .padding()
    }
}

#Preview {
    Outline()
}
