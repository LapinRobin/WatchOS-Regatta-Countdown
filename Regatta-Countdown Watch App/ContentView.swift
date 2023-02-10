//
//  ContentView.swift
//  Regatta-Countdown Watch App
//
//  Created by Su Yikang on 2023/2/10.
//

import SwiftUI


struct ContentView: View {
    @State private var timeRemaining = 60
    @State private var isCountingDown = false
    @State private var millisecondsRemaining = 0
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            HStack{
                
                Text("\(timeRemaining / 10)")
                  .font(.largeTitle)
                  .frame(width: 22)
                Text("\(timeRemaining % 10)")
                  .font(.largeTitle)
                  .frame(width: 22)
                Text(",")
                  .font(.largeTitle)
                Text("\(String(format: "%01d", millisecondsRemaining / 10))")
                  .font(.largeTitle)
                  .frame(width: 22)
                
                Text("\(String(format: "%01d", millisecondsRemaining % 10))")
                  .font(.largeTitle)
                  .frame(width: 22)
            }
            
            // .fixedSize(horizontal: true, vertical: false)
            //.frame(minWidth: 40, idealWidth: 40, maxWidth: 40, alignment: .center)

                .onReceive(timer) { _ in
                  if self.timeRemaining > 0 && self.isCountingDown {
                      if self.millisecondsRemaining == 0 {
                          self.timeRemaining -= 1
                          if self.timeRemaining == 0 {
                              self.millisecondsRemaining = 0
                          } else {
                              self.millisecondsRemaining = 99
                          }
                        
                      } else {
                        self.millisecondsRemaining -= 1
                      }
                  }
                }
             
                
              Button(action: {
                self.isCountingDown.toggle()
                if self.isCountingDown {
                    self.timeRemaining = 60
                    self.millisecondsRemaining = 0
                }
              }) {
                Text(isCountingDown ? "Stop" : "Start")
              }
                
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
