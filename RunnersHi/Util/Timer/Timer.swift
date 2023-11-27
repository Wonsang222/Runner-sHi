//
//  Timer.swift
//  AgareeGames
//
//  Created by 위사모바일 on 11/16/23.
//

import Foundation
import RxSwift
import RxRelay

class MyTimer {
    
    static let shared = MyTimer()
    let time = PublishSubject<Double>()
    let timerControlelr = BehaviorRelay(value: false)
    private var repeater:Observable<Void>!
    private let bag = DisposeBag()

    private init() {
        setTimer()
    }
    
    private func setTimer() {
        
        repeater = Observable<Int>.interval(.milliseconds(20),
                                            scheduler: SerialDispatchQueueScheduler(qos: .userInteractive))
        .map { _ in 0.02 }
        .scan(0, accumulator: { total, newValue in
            return total + newValue
        })
        .withUnretained(self)
        .flatMap{ timer, total -> Observable<Void> in
            print(total)
            if total >= Global.GAMESEC {
                timer.timerControlelr.accept(false)
                return .empty()
            }
            timer.time.onNext(total)
            return .empty()
        }
        .take(until: timerControlelr.filter({!$0}))
        
        timerControlelr
            .filter { $0 }
            .flatMap{[unowned self] _ in self.repeater }
            .subscribe()
            .disposed(by: bag)
        
    }
}
