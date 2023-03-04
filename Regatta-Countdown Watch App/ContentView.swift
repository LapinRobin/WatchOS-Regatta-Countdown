//
//  ContentView.swift
//  Regatta-Countdown Watch App
//
//  Created by Su Yikang on 2023/2/10.
//

import SwiftUI


struct ContentView: View {
    @State private var minutesRemaining = 5
    @State private var secondsRemaining = 0
    @State private var decisecondsRemaining = 0
    @State private var isReady = true
    @State private var isCountingDown = false
    @State private var isTimeUp = false
    
    @State private var buttonText = "Start"
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    func triggerHaptic(type: WKHapticType) {
        let interfaceDevice = WKInterfaceDevice.current()
        interfaceDevice.play(type)
    }
    
    var body: some View {
        VStack {
            HStack{
                Text("\(minutesRemaining)")
                    .font(.largeTitle)
                    .frame(width: 22)
                Text(":")
                    .font(.largeTitle)
                
                Text("\(secondsRemaining / 10)")
                    .font(.system(size: 66))
                    .frame(width: 36)
                Text("\(secondsRemaining % 10)")
                    .font(.system(size: 66))
                    .frame(width: 36)
                Text(",")
                    .font(.largeTitle)
                
                Text("\(String(format: "%01d", decisecondsRemaining % 10))")
                    .font(.largeTitle)
                    .frame(width: 22)
            }
            
            // .fixedSize(horizontal: true, vertical: false)
            //.frame(minWidth: 40, idealWidth: 40, maxWidth: 40, alignment: .center)
            
            .onReceive(timer) { _ in
                if self.isCountingDown {
                    if self.minutesRemaining == 0 && self.secondsRemaining == 0 && self.decisecondsRemaining == 0 {
                        triggerHaptic(type: .success)
                        self.isTimeUp = true
                        self.isCountingDown = false
                        buttonText = "Reset"
                    } else if self.decisecondsRemaining == 0 {
                        decisecondsRemaining = 9
                        if (self.secondsRemaining == 0) {
                            self.secondsRemaining = 59
                            self.minutesRemaining -= 1
                        } else {
                            self.secondsRemaining -= 1
                        }
                    } else {
                        self.decisecondsRemaining -= 1
                    }
                }
            }
            
            
            Button(action: {
                if self.isReady {
                    triggerHaptic(type: .start)
                    self.isReady.toggle()
                    self.isCountingDown.toggle()
                    buttonText = "Sync"
                } else if self.isCountingDown {
                    if minutesRemaining > 0 {
                        self.secondsRemaining = 0
                        self.decisecondsRemaining = 0
                    }
                    
                } else {
                    buttonText = "Start"
                    self.minutesRemaining = 5
                    self.isReady = true
                }
            }) {
                Text(buttonText)
            }
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
