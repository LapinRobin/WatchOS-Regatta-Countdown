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
    @State private var oneMinuteLeft = false
    
    @State private var buttonText = "Start"
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    func triggerHaptic(type: WKHapticType) {
        let interfaceDevice = WKInterfaceDevice.current()
        interfaceDevice.play(type)
    }
    
    func triggerMultipleHaptics(type: WKHapticType, count: Int, length: Double) {
        DispatchQueue.global().async {
            let interfaceDevice = WKInterfaceDevice.current()
            for _ in 0..<count {
                // Play the current haptic type
                interfaceDevice.play(type)
                
                // Wait for a short time before playing the next haptic type
                Thread.sleep(forTimeInterval: length)
            }
        }
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
                        self.oneMinuteLeft = false
                        buttonText = "Reset"
                    } else if self.decisecondsRemaining == 0 {
                        decisecondsRemaining = 9
                        if self.secondsRemaining == 0 {
                            self.secondsRemaining = 59
                            triggerMultipleHaptics(type: .click, count: minutesRemaining, length: 0.3)
                            self.minutesRemaining -= 1
                            if minutesRemaining == 0 {
                                self.oneMinuteLeft = true
                            }
                            
                        } else {
                            if oneMinuteLeft && secondsRemaining % 10 == 0 {
                                triggerMultipleHaptics(type: .click, count: secondsRemaining / 10, length: 0.2)
                            }
                            self.secondsRemaining -= 1
                        }

                        if oneMinuteLeft && secondsRemaining < 10 {
                            triggerHaptic(type: .click)
                        }
                        
                    } else {
                        self.decisecondsRemaining -= 1
                    }
                }
            }
            
            
            Button(action: {
                if self.isReady {
                    // Start
                    triggerHaptic(type: .start)
                    self.isReady.toggle()
                    self.isCountingDown.toggle()
                    buttonText = "Sync"
                } else if self.isCountingDown {
                    // Sync
                    // triggerHaptic(type: .click)
                    if minutesRemaining > 0 {
                        self.secondsRemaining = 0
                        self.decisecondsRemaining = 0
                    }
                    
                } else {
                    // Reset
                    triggerHaptic(type: .click)
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
