//
//  TabBarController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/22/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
        
        let homeScreen = getHomeScreen()
        let questionsScreen = getQuestionsScreen()
        let midiaScreen = getMidiaScreen()
        
        let viewControllerList = [homeScreen, questionsScreen, midiaScreen]
        viewControllers = viewControllerList
    }
    
    private func getHomeScreen() -> UINavigationController {
        let homeViewController = HomeRouter.createModule()
        let homeViewControllerWithNavigation = UINavigationController(rootViewController: homeViewController)
        homeViewControllerWithNavigation.tabBarItem = UITabBarItem(title: nil,
                                                                   image: UIImage(named: "icon-home")?.imageWithSize(CGSize(width: 30, height: 40)),
                                                                   selectedImage: UIImage(named: "icon-home-selected")?.imageWithSize(CGSize(width: 30, height: 40)))
        homeViewControllerWithNavigation.tabBarItem.imageInsets = UIEdgeInsets(top: 6,left: 0,bottom: -6,right: 0)
        
        return homeViewControllerWithNavigation
    }
    
    private func getQuestionsScreen() -> UINavigationController {
        let questionsViewController = QuestionsRouter.createModule()
        let questionsViewControllerWithNavigation = UINavigationController(rootViewController: questionsViewController)
        questionsViewControllerWithNavigation.tabBarItem = UITabBarItem(title: nil,
                                                                        image: UIImage(named: "icon-question")?.imageWithSize(CGSize(width: 30, height: 40)),
                                                                        selectedImage: UIImage(named: "icon-question-selected")?.imageWithSize(CGSize(width: 30, height: 40)))
        questionsViewControllerWithNavigation.tabBarItem.imageInsets = UIEdgeInsets(top: 6,left: 0,bottom: -6,right: 0)
        
        return questionsViewControllerWithNavigation
    }

    private func getMidiaScreen() -> UINavigationController {
        let midiaViewController = MidiaRouter.createModule()
        let midiaViewControllerWithNavigation = UINavigationController(rootViewController: midiaViewController)
        midiaViewControllerWithNavigation.tabBarItem = UITabBarItem(title: nil,
                                                                    image: UIImage(named: "icon-question")?.imageWithSize(CGSize(width: 30, height: 40)),
                                                                    selectedImage: UIImage(named: "icon-question-selected")?.imageWithSize(CGSize(width: 30, height: 40)))
        midiaViewControllerWithNavigation.tabBarItem.imageInsets = UIEdgeInsets(top: 6,left: 0,bottom: -6,right: 0)
        
        return midiaViewControllerWithNavigation
    }
}
