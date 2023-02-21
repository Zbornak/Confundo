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
    
    @State private var blurAmount = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.green, .white]), startPoint: .bottomLeading, endPoint: .topLeading)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Image(systemName: "eyes")
                            .font(.largeTitle)
                        Text("Confundo!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .padding(.bottom)
                    
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
                    
                    Spacer()
                    
                    HStack {
                        Text("Time remaining:")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        Text("Score:")
                    }
                    .font(.title3)
                    .fontWeight(.bold)
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
