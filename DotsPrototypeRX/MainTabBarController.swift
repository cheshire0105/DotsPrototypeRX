//
//  MainTabBarController.swift
//  DotsPrototypeRX
//
//  Created by cheshire on 10/20/23.
//



import UIKit
import Lottie

class MainTabBarController: UITabBarController {



    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.tabBar.tintColor = .blue
        self.tabBar.barTintColor = .white

        let firstVC = ViewController(viewModel: FruitsViewModel(fruits: fruits))
        let secondVC = SecondViewController()

        firstVC.tabBarItem = UITabBarItem(title: "More", image: UIImage(systemName: "ellipsis.circle.fill"), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: "More", image: UIImage(systemName: "ellipsis.circle.fill"), tag: 1)

        viewControllers = [firstVC, secondVC]

    }


}

