//
//  ContentView.swift
//  Confundo
//
//  Created by Mark Strijdom on 21/02/2023.
//

import SwiftUI

struct ContentView: View {
    let imageSet = Set(["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "dog", "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "monkey", "moose", "narwhal", "owl", "panda", "parrot", "penguin", "pig", "rabbit", "rhino", "sloth", "snake", "walrus", "whale", "zebra"])
    
    @State private var userGuess = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Confundo!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Image(imageSet.randomElement() ?? "dog")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: geometry.size.width * 0.8)
                    .shadow(radius: 10)
                    .padding()
                    
                Text("Guess the image as soon as you can!")
                    .font(.title3)
                    .fontWeight(.bold)
                
                TextField("Enter your guess here", text: $userGuess)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
