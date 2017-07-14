//
//  AnimationsTableViewController.swift
//  Animations
//
//  Created by Benjamin Encz on 6/30/15.
//  Copyright (c) 2015 Benjamin Encz. All rights reserved.
//

import UIKit

class AnimationsTableViewController: UITableViewController {
    
    let demos = [("Simple Animation", "BasicAnimationViewController"), ("Basic Constraint Demo", "BasicConstraintAnimationViewController"), ("Advanced Constraint Demo", "AdvancedConstraintViewController"), ("Complex Demo", "ComplexDemoViewController")]
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Default")!
        cell.textLabel?.text = demos[indexPath.row].0
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: demos[indexPath.row].1)
        navigationController?.pushViewController(vc, animated: true)
    }
}
