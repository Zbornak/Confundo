//
//  ContentView.swift
//  Confundo
//
//  Created by Mark Strijdom on 21/02/2023.
//

import SwiftUI

struct ContentView: View {
    let imageArray = ["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "dog", "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "monkey", "moose", "narwhal", "owl", "panda", "parrot", "penguin", "pig", "rabbit", "rhino", "sloth", "snake", "walrus", "whale", "zebra"]
    
    @State private var userGuess = ""
    
    @State private var blurAmount = 0.0
    
    @State private var userScore = 0
    
    @State private var timeRemaining = 60
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var averageTime = 0.0
    
    @State private var countdownAnimationAmount = 1.0
    
    @State private var playCount = 0
    
    var countdownButtonColor: Color {
        if timeRemaining >= 60 {
            return .green
        } else if timeRemaining <= 40 && timeRemaining > 20 {
            return .yellow
        } else if timeRemaining <= 20 {
            return .red
        } else {
            return .green
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.teal, .white]), startPoint: .bottomLeading, endPoint: .topLeading)
                    .ignoresSafeArea()
                
                VStack {
                    VStack {
                        Text("Confundo!")
                            .font(.largeTitle)
                        Text("コンファンド")
                            .font(.title3)
                    }
                    .fontWeight(.bold)
                    .padding(.bottom)
                    
                    Image(imageArray[0])
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.8)
                        .shadow(radius: 10)
                        .saturation(blurAmount)
                        .blur(radius: (1 - blurAmount) * 50)
                        .padding()
                    
                    Text("Guess the image as soon as you can!")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    TextField("Enter your guess here", text: $userGuess)
                        .textFieldStyle(.roundedBorder)
                        .shadow(radius: 10)
                        .opacity(0.7)
                    
                    Spacer()
                    
                    Text("\(timeRemaining)")
                        .fontWeight(.bold)
                        .font(.system(size: 40))
                        .padding()
                        .frame(maxWidth: geometry.size.width * 0.8)
                        .buttonStyle(.bordered)
                        .background(countdownButtonColor)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(
                            Circle()
                                .stroke(countdownButtonColor)
                                .scaleEffect(countdownAnimationAmount)
                                .opacity(2 - countdownAnimationAmount)
                                .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: false), value: countdownAnimationAmount)
                            )
                        .onAppear {
                            countdownAnimationAmount = 2.0
                        }
                        .onReceive(timer) { _ in
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                            }
                        }
                    
                    Spacer()
                    
                    Slider(value: $blurAmount)
                    
                    HStack {
                        Text("Time remaining:")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        Text("Score: \(userScore)")
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
