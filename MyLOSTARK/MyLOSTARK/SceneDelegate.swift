//
//  SceneDelegate.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let mainViewController = MainViewController()
        let searchViewController = SearchViewController()
        let scheduleViewController = ScheduleViewController()
        
        let firstNavigationController = UINavigationController(rootViewController: mainViewController)
        firstNavigationController.tabBarItem.title = "메인"
        firstNavigationController.tabBarItem.image = UIImage(systemName: "house")
        
        let secondNavigationController = UINavigationController(rootViewController: searchViewController)
        secondNavigationController.tabBarItem.title = "검색"
        secondNavigationController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        let thirdNavigationController = UINavigationController(rootViewController: scheduleViewController)
        thirdNavigationController.tabBarItem.title = "일정 관리"
        thirdNavigationController.tabBarItem.image = UIImage(systemName: "list.clipboard")
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = .systemBlue
        tabBarController.tabBar.isTranslucent = false
        tabBarController.setViewControllers([firstNavigationController, secondNavigationController, thirdNavigationController], animated: false)
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

