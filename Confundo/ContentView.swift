//
//  ContentView.swift
//  Confundo
//
//  Created by Mark Strijdom on 21/02/2023.
//

import SwiftUI

struct ContentView: View {
    let imageArray = ["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "dog", "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "monkey", "moose", "narwhal", "owl", "panda", "parrot", "penguin", "pig", "rabbit", "rhino", "sloth", "snake", "walrus", "whale", "zebra"]
    
    @State private var selectedImage = "duck"
    
    @State private var userGuess = ""
    
    @State private var blurAmount = 0.0
    
    @State private var userScore = 0
    
    @State private var timeRemaining = 30
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var averageTime = 0.0
    
    @State private var countdownAnimationAmount = 1.0
    
    @State private var playCount = 0
    
    @State private var showingTimeoutAlert = false
    
    var countdownButtonColor: Color {
        if timeRemaining >= 30 {
            return .green
        } else if timeRemaining <= 20 && timeRemaining > 10 {
            return .yellow
        } else if timeRemaining <= 10 {
            return .red
        } else {
            return .green
        }
    }
    
    let randomInt = Int.random(in: 1...30)
    
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
                    
                    Image(imageArray[randomInt])
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.8)
                        .shadow(radius: 10)
                        .saturation(blurAmount)
                        .blur(radius: (1 - blurAmount) * 30)
                        .animation(Animation.linear(duration: 30), value: blurAmount)
                        .onAppear { blurAmount = 1.0 }
                        .padding()
                    
                    Text("Guess the image as quick as you can!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    HStack {
                        Picker("", selection: $selectedImage) {
                            ForEach(imageArray, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.wheel)
                        
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
                    }
                    
                    HStack {
                        Text("Average Time: \(averageTime)")
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
        .alert("Time's up!", isPresented: $showingTimeoutAlert) {
            Button("OK") { }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
