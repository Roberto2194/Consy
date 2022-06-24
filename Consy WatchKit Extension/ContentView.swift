//
//  ContentView.swift
//  Consy WatchKit Extension
//
//  Created by Ivan Tilev on 22/01/2020.
//  Copyright © 2020 Ivan Tilev. All rights reserved.
//

import SwiftUI
import WatchKit
import Foundation

//MARK: Here we get the word ot the user and geting the results from the API call
struct ContentView: View {
    
    // The two properties for the animation ot the logo
    @State private var animateArrow = false
    @State private var animateLogo = false
    
    @State private var toggle = true
    
    @State var state = Int()
    
    // The word that the user has chosen
    @State var word = String()
    
    var body: some View {
        
        // Animation of the logo
        VStack{
            if word.isEmpty {
                ZStack {
                    Image("Logo")
                        .padding()
                        .scaleEffect(self.animateLogo ? 1 : 1.05)
                        .animation(
                            Animation.linear(duration: 0.7)
                                .repeatForever(autoreverses: true)
                    )
                        .onAppear() {
                            //toggle when click
                            self.animateLogo.toggle()
                            
                    }
                    Image("Arrows")
                        .padding()
                        .rotationEffect(.degrees(self.animateArrow ? 0 : 360))
                        .animation(
                            Animation.linear(duration: 3.00)
                                .repeatForever(autoreverses: false)
                    )
                        .onAppear() {
                            self.animateArrow.toggle()
                    }
                    
                    //Stack with the hidden TextField
                    HStack{
                        TextField(" ", text: $word)
                            .opacity(0.05)
                    }
                }
                .padding()
                NavigationLink(destination: ResultsView(chosenWord: word)) {
                    EmptyView()
                }
            } else {
                ZStack {
                    Image("Logo")
                        .padding()
                    Image("Arrows")
                        .padding()
                    //Stack with the hidden TextField
                    HStack{
                        TextField(" ", text: $word)
                            .opacity(0.05)
                    }
                }
                .padding()
                NavigationLink(destination: ResultsView(chosenWord: word)) {
                    Text(word)
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
