//
//  MainTabBarController.swift
//  DotsPrototypeRX
//
//  Created by cheshire on 10/20/23.
//

import Lottie
import UIKit

class MainTabBarController: UITabBarController {
    private let 첫번째로티 = {
        let lottieView = LottieAnimationView(name: "pop")
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 1
        lottieView.play()
        return lottieView
    }()



    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.tabBar.tintColor = .blue
        self.tabBar.barTintColor = .white
        self.delegate = self

        let firstVC = ViewController(viewModel: FruitsViewModel(fruits: fruits))
        let firstNavigationController = UINavigationController(rootViewController: firstVC)

        let secondVC = SecondViewController()

        firstVC.tabBarItem = UITabBarItem(title: "More", image: UIImage(systemName: "ellipsis.circle.fill"), tag: 0)
        firstNavigationController.tabBarItem = firstVC.tabBarItem
        secondVC.tabBarItem = UITabBarItem(title: "More", image: UIImage(systemName: "ellipsis.circle.fill"), tag: 1)

        viewControllers = [firstNavigationController, secondVC]
    }

    func 첫번째_아이탬_로티위치() {
        view.addSubview(self.첫번째로티)
        self.첫번째로티.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(150)
            make.centerX.equalToSuperview().offset(-97)
            make.centerY.equalToSuperview().offset(365)
        }
    }

    func 두번째_아이탬_로티위치() {
        view.addSubview(self.첫번째로티)
        self.첫번째로티.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(150)
            make.centerX.equalToSuperview().offset(97)
            make.centerY.equalToSuperview().offset(365)
        }
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
            print("\(index)번째 탭바 아이템이 클릭됨 - 로티 애니메이션 나옴")
            if index == 0 {
                첫번째로티.removeFromSuperview()
                첫번째_아이탬_로티위치()
                self.첫번째로티.loopMode = .loop
            } else if index == 1 {
                첫번째로티.removeFromSuperview()
                두번째_아이탬_로티위치()
                self.첫번째로티.loopMode = .loop
            }
        }
    }
}
