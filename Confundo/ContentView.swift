//
//  ContentView.swift
//  Confundo
//
//  Created by Mark Strijdom on 21/02/2023.
//

import SwiftUI

//string extension to get the nth letter in a string
extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

struct ContentView: View {
    
    //images to display and slowly unblur
    let imageArray = ["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "dog", "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "monkey", "moose", "narwhal", "owl", "panda", "parrot", "penguin", "pig", "rabbit", "rhino", "sloth", "snake", "walrus", "whale", "zebra"]
    
    //default image for the picker/player guess
    @State private var selectedImage = "duck"
    
    //player score
    @State private var userScore = 0
    
    //how much time the player has to guess the animal
    @State private var timeRemaining = 30
    
    //timer for the countdown
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    //the average time it takes for the user to correctly guess
    var averageTime: Int {
        return 0
    }
    
    //animation amount for the radiating circles around the countdown
    @State private var countdownAnimationAmount = 1.0
    
    //how many rounds the player has completed (gets more difficult as player goes along)
    @State private var playCount = 0
    
    //toggling the various user messages
    @State private var showingTimeoutAlert = false
    @State private var showingWinAlert = false
    @State private var showingLoseAlert = false
    @State private var showingGameOverAlert = false
    
    //a random integer to get a different image every play
    @State var randomInt: Int
    
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
    
    //controls when to display game over message
    @State private var gameIsOver = false
    
    //countdown linked to blur animation
    var blurAmount: Double {
        1 - (Double(timeRemaining) / 30.0)
    }
    
    //function to see if the animal starts with a vowel (for the alert messages)
    func vowelOrConsonant() -> String {
        if imageArray[randomInt][0] == "a" || imageArray[randomInt][0] == "e" || imageArray[randomInt][0] == "i" || imageArray[randomInt][0] == "o" {
            return "an"
        } else {
            return "a"
        }
    }
    
    @State private var isTimerPaused = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.teal, .white]), startPoint: .bottomLeading, endPoint: .topLeading)
                    .ignoresSafeArea()
                
                VStack {
                    VStack {
                        Text("Confundo!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("コンファンドー")
                            .font(.title3)
                    }
                    .padding(.bottom)
                    
                    if !gameIsOver {
                        Image(imageArray[randomInt])
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: geometry.size.width * 0.8)
                            .shadow(radius: 10)
                            .saturation(blurAmount)
                            .blur(radius: (1 - blurAmount) * 30)
                            .padding()
                        
                        Text("Guess the image as quick as you can!")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top)
                    } else {
                        Spacer()
                        
                        Text("Thanks for playing!")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom)
                        
                        Button {
                            gameIsOver = false
                            userScore = 0
                            newRound()
                        } label: {
                            Text("Play again")
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.black)
                        .background(.orange)
                        .font(.title)
                        .fontWeight(.bold)
                        .clipShape(Capsule())
                        .shadow(radius: 10)
                        .padding()
                        
                        Spacer()
                    }
                    
                    HStack {
                        Picker("", selection: $selectedImage) {
                            ForEach(imageArray, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.wheel)
                        
                    VStack {
                        Button {
                            gameCondition()
                        } label: {
                            Text("Guess!")
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.black)
                        .background(.orange)
                        .font(.title)
                        .fontWeight(.bold)
                        .clipShape(Capsule())
                        .shadow(radius: 10)
                        .padding()
                            
                        if !gameIsOver {
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
                                        if !isTimerPaused {
                                            timeRemaining -= 1
                                        }
                                    } else {
                                        showingTimeoutAlert = true
                                    }
                                }
                            } else {
                                Text("0")
                                    .fontWeight(.bold)
                                    .font(.system(size: 40))
                                    .padding()
                                    .frame(maxWidth: geometry.size.width * 0.8)
                                    .buttonStyle(.bordered)
                                    .background(.green)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Text("Score: \(userScore)")
                            .font(.title3)
                            .fontWeight(.bold)
                }
                .padding()
            }
        }
        .alert("Time's up!", isPresented: $showingTimeoutAlert) {
            Button("Continue") {
                newRound()
            }
        } message: {
            Text("It was \(vowelOrConsonant()) \(imageArray[randomInt])")
        }
        
        .alert("Correct!", isPresented: $showingWinAlert) {
            Button("Continue") {
                newRound()
            }
        } message: {
            Text("It was \(vowelOrConsonant()) \(imageArray[randomInt])")
        }
        
        .alert("Oops, wrong!", isPresented: $showingLoseAlert) {
            Button("Continue") {
                newRound()
            }
        } message: {
            Text("It was \(vowelOrConsonant()) \(imageArray[randomInt])")
        }
        
        .alert("Game Over!", isPresented: $showingGameOverAlert) {
            Button("Finish") {
               gameIsOver = true
            }
            Button("Play again") {
                userScore = 0
                newRound()
            }
        } message: {
            Text("You scored \(userScore) out of 10")
        }
    }
    
    init() {
        randomInt = Int.random(in: 1..<30)
    }
    
    func gameCondition() {
        if selectedImage == imageArray[randomInt] {
            showingWinAlert = true
            userScore += 1
            playCount += 1
            isTimerPaused = true
        } else {
            showingLoseAlert = true
            playCount += 1
            isTimerPaused = true
        }
    }
    
    func newRound() {
        if playCount <= 10 {
            randomInt = Int.random(in: 1..<30)
            timeRemaining = 30
            isTimerPaused = false
        } else {
            showingGameOverAlert = true
            playCount = 0
            isTimerPaused = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
