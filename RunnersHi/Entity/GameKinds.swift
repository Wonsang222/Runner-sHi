//
//  GameKinds.swift
//  AgareeGames_dis
//
//  Created by 황원상 on 2023/08/13.
//

import UIKit
import RxSwift

public enum GameKinds:String{
    case GuessWho = "인물퀴즈"
}

extension GameKinds{
    var gameTitle:String{
        switch self{
        case .GuessWho:
            return self.rawValue
        }
    }
    
    func getObservable() -> Observable<Self>{
        return Observable.create { emitter in
            emitter.onNext(self)
            emitter.onCompleted()
            return Disposables.create()
        }
    }
}
