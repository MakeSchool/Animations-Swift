//
//  AnimationsTableViewController.swift
//  Animations
//
//  Created by Benjamin Encz on 6/30/15.
//  Copyright (c) 2015 Benjamin Encz. All rights reserved.
//

import UIKit

class AnimationsTableViewController: UITableViewController {
    
    let demos = [("Simple Animation", "BasicAnimationViewController"), ("Basic Constraint Demo", "BasicConstraintAnimationViewController"), ("Advanced Constraint Demo", "AdvancedConstraintViewController"), ("Complex Demo", "ViewController")]
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Default") as! UITableViewCell
        cell.textLabel?.text = demos[indexPath.row].0
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(demos[indexPath.row].1) as! UIViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
