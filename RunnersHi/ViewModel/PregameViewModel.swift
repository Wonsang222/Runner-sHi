//
//  PregameViewModel.swift
//  AgareeGames
//
//  Created by 황원상 on 2023/08/12.
//

import UIKit
import RxSwift
import RxCocoa


// take1은 언제쓰는가

final class PregameViewModel{
    //MARK: -  INPUT
    let gameModel:BehaviorRelay<PregameModel>
    let changePlayerTrigger = PublishSubject<Int>()
    
    //MARK: - OUTPUT
    lazy var gameTitle:Observable<String> = {
        return getGameTitle()
    }()
    lazy var gameInstruction:Observable<GuessWhoHTPV> = {
        return setInstruction()
    }()
    
    private let disposeBag = DisposeBag()
    
    // Lifecycle
    
    init(game:GameKinds){
        let baseModel = PregameModel(gameType: game)
        gameModel = BehaviorRelay(value: baseModel)
        bindInputs()
    }
    
    private func bindInputs() {
        changePlayerTrigger
            .withLatestFrom(gameModel) { (index: $0, model: $1) }
            .map (changePlayers)
            .bind(to: gameModel)
            .disposed(by: disposeBag)
    }
    
    private func changePlayers(_ num:Int, _ model:PregameModel) -> PregameModel {
        let revisionNum = num + 2
        return PregameModel(origin: model, num: revisionNum)
    }
    
    private func setInstruction() -> Observable<GuessWhoHTPV> {
        return gameModel
            .asObservable()
            .observe(on: MainScheduler.instance)
            .map{ model in
                switch model.gameType.gameTitle{
                case "인물퀴즈":
                    return GuessWhoHTPV()
                default:
                    break
                }
                return GuessWhoHTPV()
            }
    }
    
    private func getGameTitle() -> Observable<String>{
        return gameModel
            .asObservable()
            .observe(on: MainScheduler.instance)
            .map{ $0.gameType.gameTitle }
    }
    
    private func setGameController() -> Observable<GuessWhoController>{
        return Observable.create { emitter in
            emitter.onNext(GuessWhoController())
            return Disposables.create()
        }
    }
}




