//
//  BaseViewModel.swift
//  AgareeGames
//
//  Created by 황원상 on 2023/09/03.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel:NSObject{
    let sceneCoordinator:SceneCoordinatorType
//    let storage
    
    init(sceneCoordinator: SceneCoordinatorType) {
        self.sceneCoordinator = sceneCoordinator
    }
}