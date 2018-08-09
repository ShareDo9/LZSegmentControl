//
//  CellViewController.swift
//  LZSegmentControl
//
//  Created by Ray on 2018/7/2.
//  Copyright © 2018年 ray. All rights reserved.
//

import UIKit

class CellViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "比例下划线"
        case 1:
            cell.textLabel?.text = "字体宽度下划线"
        case 2:
            cell.textLabel?.text = "固定宽度下划线"
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.present(ScaleLineViewController(), animated: true, completion: nil)
        case 1:
            self.present(FontWidthViewController(), animated: true, completion: nil)
        case 2:
            self.present(FixedWidthLineViewController(), animated: true, completion: nil)
        default:
            break
        }
    }

}
