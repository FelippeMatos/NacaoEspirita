//
//  TabBarController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/22/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    let sizeOfIcon = CGSize(width: 23, height: 23)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let homeScreen = getHomeScreen()
        let questionsScreen = getQuestionsScreen()
        let midiaScreen = getMidiaScreen()
        let profileScreen = getProfileScreen()
        
        let viewControllerList = [homeScreen, questionsScreen, midiaScreen, profileScreen]
        viewControllers = viewControllerList
    }
    
    private func getHomeScreen() -> UINavigationController {
        let homeViewController = HomeRouter.createModule()
        let homeViewControllerWithNavigation = UINavigationController(rootViewController: homeViewController)
        homeViewControllerWithNavigation.tabBarItem = UITabBarItem(title: "Início",
                                                                   image: UIImage(named: "icon-home")?.imageWithSize(sizeOfIcon), tag: 0)
        
        return homeViewControllerWithNavigation
    }
    
    private func getQuestionsScreen() -> UINavigationController {
        let questionsViewController = QuestionsRouter.createModule()
        let questionsViewControllerWithNavigation = UINavigationController(rootViewController: questionsViewController)
        questionsViewControllerWithNavigation.tabBarItem = UITabBarItem(title: "Questões",
                                                                        image: UIImage(named: "icon-question")?.imageWithSize(sizeOfIcon), tag: 1)
        
        return questionsViewControllerWithNavigation
    }

    private func getMidiaScreen() -> UINavigationController {
        let midiaViewController = MidiaRouter.createModule()
        let midiaViewControllerWithNavigation = UINavigationController(rootViewController: midiaViewController)
        midiaViewControllerWithNavigation.tabBarItem = UITabBarItem(title: "Mídias",
                                                                    image: UIImage(named: "icon-midia")?.imageWithSize(sizeOfIcon), tag: 2)
        
        return midiaViewControllerWithNavigation
    }
    
    private func getProfileScreen() -> UINavigationController {
        let midiaViewController = ProfileRouter.createModule()
        let midiaViewControllerWithNavigation = UINavigationController(rootViewController: midiaViewController)
        midiaViewControllerWithNavigation.tabBarItem = UITabBarItem(title: "Perfil",
                                                                    image: UIImage(named: "icon-profile")?.imageWithSize(sizeOfIcon), tag: 3)
        
        return midiaViewControllerWithNavigation
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        var tabBarView: [UIView] = []

        for i in tabBar.subviews {
            if i.isKind(of: NSClassFromString("UITabBarButton")! ) {
                tabBarView.append(i)
            }
        }

        if !tabBarView.isEmpty {
            UIView.animate(withDuration: 0.15, animations: {
                tabBarView[item.tag].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { _ in
                UIView.animate(withDuration: 0.15) {
                    tabBarView[item.tag].transform = CGAffineTransform.identity
                }
            })
        }
    }
}


