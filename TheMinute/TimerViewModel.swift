//
//  TimerViewModel.swift
//  TheMinute
//
//  Created by Sébastien Roger on 01.06.24.
//

import Foundation
import Combine

public protocol TimerViewModelProtocol: ObservableObject {
    func startPauseTimer()
    func resetTimer()
    var isRunning : Bool { get }
    var ringAnimation: TimerRingAnimation { get }
    var elapsedTime: TimeInterval { get }
    var numberDisplay: TimerNumberDisplay { get }
    var startPauseButtonText: String { get }
}

public class TimerRingAnimation {
    var startPosition : Double
    var endPosition : Double
    var duration : Double
    
    init(startPosition: Double, endPosition: Double, duration: Double) {
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.duration = duration
    }
}

public class TimerNumberDisplay {
    var minutes : String
    var seconds : String
    var milliseconds : String
    
    init(minutes: String, seconds: String, milliseconds: String) {
        self.minutes = minutes
        self.seconds = seconds
        self.milliseconds = milliseconds
    }
}

public class TimerViewModel: TimerViewModelProtocol
{
    
    @Published public var isRunning: Bool = false
    @Published public var ringAnimation: TimerRingAnimation
    @Published public var elapsedTime: TimeInterval = 0
    @Published public var numberDisplay: TimerNumberDisplay
    @Published public var startPauseButtonText: String = "Start"
    
    private var startOffset: TimeInterval = 0
    private var startDate: Date?
    private var cancellableTimer: Cancellable?
    @Published private var lastTimerDate: Date = Date()
    private var finishedTimerBinding: Cancellable?
    private var notificationService: NotificationServiceProtocol
    
    init(notificationService : NotificationServiceProtocol) {
        ringAnimation = TimerRingAnimation(startPosition: 0, endPosition: 0, duration: 0)
        numberDisplay = TimerNumberDisplay(minutes: "1", seconds: "00", milliseconds: "000")
        self.notificationService = notificationService
        initiateDataBindings()
    }
    
    func initiateDataBindings() {
        $isRunning
            .map { $0 ?
                TimerRingAnimation(startPosition: self.startOffset / 60, endPosition: 1, duration: 60 - self.startOffset) :
                TimerRingAnimation(startPosition: self.startOffset / 60, endPosition: self.startOffset / 60, duration: 0)}
            .assign(to: &$ringAnimation)
        
        $elapsedTime
                .map {
                    TimerNumberDisplay(
                        minutes: String(format: "%01d", Int(60 - $0) / 60),
                        seconds: String(format: "%02d", Int(60 - $0) % 60),
                        milliseconds: String(format: "%03d", Int(round((60 - $0) * 1000)) % 1000)
                    )
                }
                .assign(to: &$numberDisplay)
        
        $lastTimerDate
                .map { [weak self] in
                    if let startDate = self?.startDate, let startOffset = self?.startOffset {
                       return  min($0.timeIntervalSince(startDate) + (startOffset), 60)
                    } else {
                        return 0
                    }
                }
                .assign(to: &$elapsedTime)

        finishedTimerBinding = $elapsedTime
            .filter { $0 > 60 }
            .sink { [weak self] _ in
                self?.cancellableTimer?.cancel()
                self?.elapsedTime = 60
                self?.isRunning = false
            }
    }
    
    public func startPauseTimer() {
        guard elapsedTime < 60 else { return }
        
        startOffset = elapsedTime
        isRunning = !isRunning
        
        $isRunning
            .map { $0 ? "Pause" : "Start" }
            .assign(to: &$startPauseButtonText)
        
        if(isRunning) {
            startDate = Date()
            cancellableTimer = Timer.publish(every: 0.05, on: .main, in: .default)
                    .autoconnect()
                    .receive(on: DispatchQueue.main)
                    .assign(to: \.lastTimerDate, on: self)
            
            notificationService.scheduleNotification(timeInterval: 60 - startOffset)
        } else {
            elapsedTime += Date().timeIntervalSince(lastTimerDate)
            cancellableTimer?.cancel()
            notificationService.cancelScheduledNotification()
        }
    }
    
    public func resetTimer() {
        cancellableTimer?.cancel()
        notificationService.cancelScheduledNotification()
        startOffset = 0
        elapsedTime = 0
        isRunning = false
    }
}
