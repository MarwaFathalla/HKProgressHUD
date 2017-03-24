//
//  ViewController.swift
//  HubDemo
//
//  Created by kang huawei on 2017/3/21.
//  Copyright © 2017年 huaweikang. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let examples = [
        ("Indeterminate mode", #selector(indeterminateExample)),
        ("With label", #selector(labelExample)),
        ("With details label", #selector(detailsLabelExample)),
        ("On window", #selector(windowExample)),
        ("Bar determinate mode", #selector(bardeterminateExample)),
        ("Determinate mode", #selector(determinateExample))
                    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setUp() {
        self.title = "Hub Test"
        
    }
    
    // MARK: Examples
    func indeterminateExample() {
        // Show the hub on the root view (self.view is a scrollable table view and thus not suitable,
        // as the hub would move with the content as we scroll).
        let hub = ProgressHub.show(addedToView: (self.navigationController?.view)!, animated: true)
        
        // Fire off an asynchronous task, giving UIKit the opportunity to redraw wit the hub added to the
        // view hierarchy.
        DispatchQueue.global(qos: .userInitiated).async {
            self.doSomeWork()
            
            DispatchQueue.main.async {
                hub.hide(animated: true)
            }
        }
    }
    func labelExample() {
        
    }
    func detailsLabelExample() {
        
    }
    func windowExample() {
        
    }
    
    func bardeterminateExample() {
        let hub = ProgressHub.show(addedToView: (self.navigationController?.view)!, animated: true)
        hub.mode = .determinateHorizontalBar
        hub.label?.text = "Loading..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Do something useful in the background and update the hub periodically.
            self.doSomeWorkWithProgess()
            DispatchQueue.main.async {
                hub.hide(animated: true)
            }
        }
    }
    
    func determinateExample() {
        let hub = ProgressHub.show(addedToView: (self.navigationController?.view)!, animated: true)
        
        // Set determinate mode
        hub.mode = .determinate
        hub.label?.text = NSLocalizedString("Loading...", comment: "Hub loading title")
        hub.progress = 0.5
        DispatchQueue.global(qos: .userInitiated).async {
            // Do something useful in the background and update the hub periodically.
            self.doSomeWorkWithProgess()
            DispatchQueue.main.async {
                hub.hide(animated: true)
            }
        }
    }
    
    
    // MARK - Tasks
    func doSomeWork() {
        sleep(3)
    }
    
    var canceled = false
    func doSomeWorkWithProgess() {
        var progress: Float = 0.0
        canceled = false
        while (progress < 1.0) {
            if (self.canceled) {
                break
            }
            progress += 0.01
            DispatchQueue.main.async {
                ProgressHub.hubForView((self.navigationController?.view)!)?.progress = progress
            }
            usleep(50000)
        }
    }

    
    // MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "exampleCell"
        let exapmle = examples[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = exapmle.0
        cell.textLabel?.textColor = self.view.tintColor
        cell.textLabel?.textAlignment = .center
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = cell.textLabel?.textColor.withAlphaComponent(0.1)
        return cell
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let example = examples[indexPath.row]
        perform(example.1)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            tableView.deselectRow(at: indexPath, animated: true)
        })
    }
}

