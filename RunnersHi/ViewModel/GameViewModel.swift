//
//  GameViewModel.swift
//  AgareeGames
//
//  Created by 황원상 on 10/31/23.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

// fetching + start

class GameViewModel<T>:BaseViewModel where T:Playable {
    
    private var targetArr = [T]()
    
    let fetchTargets:AnyObserver<Void>
    let startGame:AnyObserver<Void>
    let loadTarget:PublishRelay<Void>

    // output
    let target = BehaviorRelay<GamePlayModel?>(value: nil)
    
    init<V>(game:V, coordinator:Coordinator) where V:Networkable {
        
        let fetching = PublishSubject<Void>()
        let fetchImages = PublishSubject<Dictionary<String, String>>()
        let starting = PublishSubject<Void>()
        let reloading = PublishSubject<Void>()
    
        fetchTargets = fetching.asObserver()
        startGame = starting.asObserver()
        loadTarget = PublishRelay<Void>()
        
        super.init(sceneCoordinator: coordinator)
        
        fetching
            .flatMap{ NetworkService.shared.fetchJsonRX(resource: game.getParam()) }
            .do(onError: { [weak self] err in
                self?.errorMessage.onNext(err)
            })
            .subscribe(onNext: { json in
                fetchImages.onNext(json)
            })
            .disposed(by: rx.disposeBag)
        
        fetchImages
            .flatMap{ NetworkService.shared.fetchImageRX(source: $0)}
            .do(onError: { [weak self] err in
                self?.errorMessage.onNext(err)
            })
            .subscribe(onNext: { [unowned self] targets in
                self.target = targets
            })
            .disposed(by: rx.disposeBag)
        
//        loadTarget
//            .withUnretained(self)
//            .do(onNext: { viewmodel, _ in
//                // 리피터를 연결 끊고 다시 시작
//                
//            })
//            .
//        
//        // timer + loadTarget + STT?   -> 에러 메세지 체크 프로세스
//        starting
//            .do(onNext: { [weak self] _ in
//                
//            })
//            .withUnretained(self)
//            .flatMap{ vm, _ in vm.repeater }
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] second in
//                self?.timer.onNext(second)
//            })
//            .disposed(by: rx.disposeBag)
    }
    
    private func answerAction() -> Action<String, Void> {
        return Action<String, Void> { [unowned self] input in
            
            guard let answer = self.target.value?.name else {
                errorMessage.onNext(GameError.InGame)
                return .empty()
            }
                
            let submit = input.components(separatedBy: "").joined()
 
            guard answer.contains(submit) else {
                return Observable.just(())
            }
            
            loadTarget.accept(())
            return Observable.just(())
        }
    }
    
    private func judgeAction(isWin:Bool) -> Action<Void, Void> {
        
        return Action<Void, Void> { [unowned self] _ in
            let viewModel = ResultViewModel(isWin: true, sc: self.sceneCoordinator)
            let nextScene:Scene = .Play(.result(viewModel))
            return sceneCoordinator.transition(to: nextScene
                                               , using: .push
                                               , animation: true)
            .asObservable()
            .map { _ in } 
        }
    }
}
