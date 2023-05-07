//
//  ResultController.swift
//  RunnersHi
//
//  Created by 황원상 on 2023/05/04.
//

import UIKit

final class ResultController:SettingController{
    
    var isWin:Bool
    let resultView = ResultView()
    
    override func loadView() {
        view = resultView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
// 땡 소리 넣기
        if isWin{
            resultView.label.text = "정답"
        } else {
            resultView.label.text = "땡!"
        }
        
    }
    
    init(isWin: Bool) {
        self.isWin = isWin
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
