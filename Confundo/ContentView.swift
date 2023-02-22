//
//  ContentView.swift
//  Confundo
//
//  Created by Mark Strijdom on 21/02/2023.
//

import SwiftUI

struct ContentView: View {
    
    //images to display and slowly unblur
    let imageArray = ["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "dog", "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "monkey", "moose", "narwhal", "owl", "panda", "parrot", "penguin", "pig", "rabbit", "rhino", "sloth", "snake", "walrus", "whale", "zebra"]
    
    //default image for the picker
    @State private var selectedImage = "duck"
    
    //the guess the player gives
    @State private var userGuess = ""
    
    //starting blur for the image animation
    @State private var blurAmount = 0.0
    
    //player score
    @State private var userScore = 0
    
    //how much time the player has to guess the animal
    @State private var timeRemaining = 30
    
    //timer for the countdown
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    //the average time it takes for the user to correctly guess
    var averageTime: Double {
        return 0.0
    }
    
    //animation amount for the radiating circles around the countdown
    @State private var countdownAnimationAmount = 1.0
    
    //how many rounds the player has completed (gets more difficult as player goes along)
    @State private var playCount = 0
    
    //toggling the timeout message
    @State private var showingTimeoutAlert = false
    
    //countdown image changes as the time runs out
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
    
    //generates a random integer to get a different image every play
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
                                } else {
                                    showingTimeoutAlert = true
                            }
                        }
                    }
                    
                    HStack {
                        Text("Average Time: \(averageTime, specifier: "%.2f")")
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
            Button("Continue") { }
        } message: {
            Text("It was a ...animal name here...")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
