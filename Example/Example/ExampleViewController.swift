//
//  ExampleViewController.swift
//  LZSegmentControl
//
//  Created by ray on 2017/5/8.
//  Copyright © 2017年 ray. All rights reserved.
//

import UIKit

let SCREEN_WIDTH    = UIScreen.main.bounds.width
let SCREEN_HEIGHT   = UIScreen.main.bounds.height
let SCREEN_BOUNDS   = UIScreen.main.bounds


class ExampleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView(frame: CGRect.init(x: 0.0, y: 20.0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 20.0),
                                style: .grouped)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "默认"
        case 1:
            cell.textLabel?.text = "下划线"
        case 2:
            cell.textLabel?.text = "字体缩放"
        case 3:
            cell.textLabel?.text = "无效果"
        case 4:
            cell.textLabel?.text = "多个按钮"
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.present(NormalViewController(), animated: true, completion: nil)
        case 1:
            self.present(CellViewController(), animated: true, completion: nil)
        case 2:
            self.present(NoFontScaleViewController(), animated: true, completion: nil)
        case 3:
            self.present(NoEffectViewController(), animated: true, completion: nil)
        case 4:
            self.present(MoreViewController(), animated: true, completion: nil)
        default:
            break
        }
    }
    
    
}

func randomColor() -> UIColor {
    
    let randomR = CGFloat(arc4random()%255) / 255.0
    let randomG = CGFloat(arc4random()%255) / 255.0
    let randomB = CGFloat(arc4random()%255) / 255.0
    
    return UIColor(red: randomR, green: randomG, blue: randomB, alpha: 1.0)
}
