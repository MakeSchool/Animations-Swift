//
//  AnimationsTableViewController.swift
//  Animations
//
//  Created by Benjamin Encz on 6/30/15.
//  Copyright (c) 2015 Benjamin Encz. All rights reserved.
//

import UIKit

class AnimationsTableViewController: UITableViewController {
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Default") as! UITableViewCell
        cell.textLabel?.text = "Complex Demo"
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as! UIViewController
        navigationController?.pushViewController(vc, animated: false)
    }
}
