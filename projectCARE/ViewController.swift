//
//  ViewController.swift
//  projectCARE
//
//  Created by Ekta Shahani on 2/1/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import UIKit
import Charts

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

class ViewController: UIViewController {

    let store:HealthStore = HealthStore.getInstance()
    let screenHeight = UIScreen.main.bounds.height

    var chtChart = BarChartView(frame: CGRect(x: 15, y: 160, width: 330, height: 310))
    var barsData : [(title: String, stepCount: Int)] = []

    @IBAction func SleepAnalysis(_ sender: UIButton) {
        performSegue(withIdentifier: "SleepAnalysis", sender: self)
    }
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    private let imageView = UIImageView(image: UIImage(named: "heart"))
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 45
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 32
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    private func setupUI() {
        
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
        imageView.contentMode = UIViewContentMode.scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI();
        
        navigationTitle.title = "CARE"
        
        
        //step count chart
        let group = DispatchGroup()
        group.enter()
        store.retrieveStepCount() { steps in
            for step in steps {
                self.barsData.append((title: step.date, stepCount: Int(step.steps)))
            }
            group.leave()
        }
        group.wait()
        generateCharts.updateStepsGraph(stepsData: barsData, chtChart: chtChart)
        view.addSubview(chtChart)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // 1
        let nav = self.navigationController?.navigationBar
        
        // 2
        let deepBlue = UIColor(rgb: 0x293044)
        let fontColor = UIColor(rgb: 0xE6E6E6)
        nav?.tintColor = fontColor
        
        // 3
        let imageView = UIImageView(frame: CGRect(x: 0, y: 20, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        
        // 4
        let image = UIImage(named: "heart")
        imageView.image = image
        
        // 5
        //navigationItem.titleView = imageView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

