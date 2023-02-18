//
//  ContentView.swift
//  Regatta-Countdown Watch App
//
//  Created by Su Yikang on 2023/2/10.
//

import SwiftUI


struct ContentView: View {
    @State private var minutesRemaining = 5
    @State private var secondsRemaining = 60
    @State private var millisecondsRemaining = 0
    @State private var isReady = true
    @State private var isCountingDown = false
    @State private var isTimeUp = false
    
    @State private var buttonText = "Start"
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

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
                Text("\(String(format: "%01d", millisecondsRemaining / 10))")
                    .font(.system(size: 20))
                    .alignmentGuide(.bottom) { d in d[.bottom] }
                    .frame(width: 11)
                
                Text("\(String(format: "%01d", millisecondsRemaining % 10))")
                  .font(.system(size: 20))
                  .alignmentGuide(.bottom) { d in d[.bottom] }
                  .frame(width: 11)
            }
            
            // .fixedSize(horizontal: true, vertical: false)
            //.frame(minWidth: 40, idealWidth: 40, maxWidth: 40, alignment: .center)

                .onReceive(timer) { _ in
                  if self.secondsRemaining > 0 && self.isCountingDown {
                      if self.millisecondsRemaining == 0 {
                          self.secondsRemaining -= 1
                          if self.secondsRemaining == 0 {
                              self.millisecondsRemaining = 0
                              self.isCountingDown = false
                              self.isTimeUp = true
                              buttonText = "Reset"
                          } else {
                              self.millisecondsRemaining = 99
                          }
                        
                      } else {
                        self.millisecondsRemaining -= 1
                      }
                  }
                }
             
                
              Button(action: {
                  if self.isReady {
                      self.isReady.toggle()
                      self.isCountingDown.toggle()
                      buttonText = "Sync"
                  } else if self.isCountingDown {
                      if secondsRemaining > 5 {
                          self.secondsRemaining -= 5
                      }
                      
                  } else {
                      buttonText = "Start"
                      self.secondsRemaining = 60
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
