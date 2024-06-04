//
//  ContentView.swift
//  TheMinute
//
//  Created by Sébastien Roger on 01.06.24.
//

import SwiftUI

struct TimerView: View {
    @StateObject var timerViewModel: TimerViewModel
    
    var body: some View {
        VStack {
            Text("One Minute Timer")
                .font(.largeTitle)
            ZStack {
                CircularProgressView(startValue: timerViewModel.ringAnimation.startPosition, endValue: timerViewModel.ringAnimation.endPosition, animationDuration: timerViewModel.ringAnimation.duration)
                    .padding()
                Text("\(timerViewModel.numberDisplay.minutes) : \(timerViewModel.numberDisplay.seconds) : \( timerViewModel.numberDisplay.milliseconds) " ).font(.largeTitle)
                    .padding()
            }
            HStack {
                Button(timerViewModel.startPauseButtonText, action: timerViewModel.startPauseTimer)
                    .font(.title)
                    .padding()
                Button("Reset", action: timerViewModel.resetTimer)
                    .font(.title)
                    .padding()
            }
        }
        .padding()
    }
}

struct CircularProgressView: View {
    let startValue: CGFloat
    let endValue: CGFloat
    let animationDuration: TimeInterval

  var body: some View {
    ZStack {
        Circle()
            .stroke(lineWidth: 20)
            .opacity(0.1)
            .foregroundColor(.blue)

        Circle()
            .trim(from: 0.0, to: min(startValue, 1.0))
            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .miter))
            .foregroundColor(.blue)
            .rotationEffect(Angle(degrees: 270.0))

        Circle()
            .trim(from: startValue, to: min(endValue, 1.0))
            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
            .foregroundColor(.blue)
            .rotationEffect(Angle(degrees: 270.0))
            .animation(.linear(duration: animationDuration), value: endValue)
    }
  }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timerViewModel: TimerViewModel(notificationService: NotificationServiceMock()))
    }
}
