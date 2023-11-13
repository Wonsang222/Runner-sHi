//
//  GuessWhoController.swift
//  RunnersHi
//
//  Created by 황원상 on 2023/04/26.
//

import UIKit
import Speech

final class GuessWhoController:GameController{
    
    //MARK: - Properties
    private let guessView = GuessWhoView()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

    }
    //MARK: - Methods
    private func configureUI(){
        view.addSubview(guessView)
//        guessView.addSubview(countView)
//        guessView.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            guessView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            guessView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            guessView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            guessView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
//            countView.centerXAnchor.constraint(equalTo: guessView.centerXAnchor),
//            countView.centerYAnchor.constraint(equalTo: guessView.centerYAnchor),
//            countView.heightAnchor.constraint(equalToConstant: 200),
//            countView.widthAnchor.constraint(equalToConstant: 200),
//
//            progressView.widthAnchor.constraint(equalTo: guessView.widthAnchor, multiplier: 0.5),
//            progressView.heightAnchor.constraint(equalToConstant: 20),
//            progressView.centerXAnchor.constraint(equalTo: guessView.centerXAnchor),
//            progressView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150)
        ])
    }
    
    private func startGame(){
//        if !viewModel.isNetworkDone{ loaderON() }
//        countView.removeFromSuperview()
//        guessView.imageView.isHidden = false
//        progressView.isHidden = false
        
//        countView.layoutIfNeeded()
//        if let serverErr = viewModel.networkErr{
//            handleErrors(error: serverErr)
//        }
//        viewModel.next()
    }
 
    func checkTheAnswer()->Bool{
//        guard let targetName = viewModel.getTargetModel?.name else { return false }
//        print(targetName)
//        let answer = answer.components(separatedBy: " ").joined()
//        if answer.contains(targetName){
//            return true
//        }
//        return false
        return true
    }
    
//    override func checkTheProcess(){
////        print(#function)
////        //정답 맞춘경우
////        if checkTheAnswer(){
////            timer?.invalidate()
////            timer = nil
////            viewModel.next()
////            print("마즘")
////        }
////    }
//    override func startGameTimer(_ timer: Timer) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            if self.numToCount >= 1.0 {
//                timer.invalidate()
//                self.timer = nil
//                self.isRunning = false
//                self.clearGame(isWin: false)
//            }
//            self.numToCount += self.speed
//            self.progressView.setProgress(self.numToCount, animated: true)
//        }
//    }
}
