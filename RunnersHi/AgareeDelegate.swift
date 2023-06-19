//
//  AgareeDelegate.swift
//  AgareeGames_dis
//
//  Created by 위사모바일 on 2023/06/07.
//

import UIKit

let initialKey = "initialKey"
let thresholdKey = "thresholdKey"
let homePath = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!

class AgareeDelegate: UIResponder, UIWindowSceneDelegate, UIApplicationDelegate{
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        var libraryFolderUrl = homePath.appendingPathComponent(Global.PHOTODB, isDirectory: true)
        print(libraryFolderUrl)
        
        if !UserDefaults.standard.bool(forKey: initialKey){
            //처음 부팅
            let defaultSettings = [thresholdKey:123] as [String:Any]
            UserDefaults.standard.register(defaults: defaultSettings)
            do{
                try FileManager.default.createDirectory(at: libraryFolderUrl, withIntermediateDirectories: true)
                var value = try libraryFolderUrl.resourceValues(forKeys: [.isExcludedFromBackupKey])
                value.isExcludedFromBackup = true
                try libraryFolderUrl.setResourceValues(value)
                print("wonsang: created directory")
            }catch{
                print("wonsang: create lib folder error")
            }
            
            UserDefaults.standard.set(true, forKey: initialKey)
        } else{
            // 여기서 로딩하거나...
        }
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print(#function)
        // 전화올때, 앱나갈때 스톱 그리고 다시 돌아오면 alert하고 pop
        if let rootVC = UIApplication.shared.keyWindow as? UINavigationController{
            if let vc = rootVC.topViewController as? TimerGameCotoller{
                vc.timer?.invalidate()
                vc.timer = nil
            }
            if let mainVC = rootVC.topViewController as? TalkGameController{
                mainVC.engine?.offEngine()
            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        // 이거 잘못됐다
        guard let windowScene = application.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController as? CustomUINavigationController,
              let topVC = rootVC.topViewController else { return }
        
        switch topVC{
        case is TimerGameCotoller:
            print(123123)
            fallthrough
        case is GameController:
            print(12312312)
            fallthrough
        default:
            break
            
        }
//
//        if let currentVC = rootVC.topViewController as? TimerGameCotoller{
//
//        }
//        if let currentVC = rootVC.topViewController as? GameController{
//
//        }
        
        
//        if let rootVC = window.rootViewController as? TimerGameCotoller {
//            print("yay")
//        }
//        if let rootVC = window.rootViewController as? GameController{
//            rootVC.alert(message: "게임이 중단되었습니다. \n 첫 화면으로 돌아갑니다.", agree: { alert in
//                rootVC.goBackToRoot()
//            }, disagree: nil)
//        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
//        window?.rootViewController = ResultController(isWin: true)
//        window?.rootViewController = PreGameController(gameTitle: "dsfsda")
//        window?.rootViewController = CustomUINavigationController(rootViewController: PreGameController(gameTitle: "인물게임"))
        window?.rootViewController = EmptyController()
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        guard let windowScenne = scene as? UIWindowScene else { return }
        
        
        
        if let rootVC = UIApplication.shared.keyWindow as? UINavigationController{
            if let vc = rootVC.topViewController as? TimerGameCotoller{
                vc.timer?.invalidate()
                vc.timer = nil
            }
            if let mainVC = rootVC.topViewController as? TalkGameController{
                mainVC.engine?.offEngine()
            }
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        if let windowScene = scene as? UIWindowScene{
            print("windowscene")
            if let rootVC = windowScene.windows.first?.rootViewController as? CustomUINavigationController{
                if let vc = rootVC.topViewController as? GameController{
                    print("젭알")
                }
            }
        }
    }
}
