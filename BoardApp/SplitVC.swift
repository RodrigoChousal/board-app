//
//  SplitVC.swift
//  BoardApp
//
//  Created by Rodrigo Chousal on 8/28/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit

class SplitVC: UISplitViewController {
    
    var meeting: Meeting!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Amount of view controllers in split: " + self.childViewControllers.count.description)
        
        if let navigationVC = self.childViewControllers[0] as? UINavigationController {
            if let listVC = navigationVC.topViewController as? TopicListTVC {
                listVC.topics = meeting.topics
            }
        }
        
        if let detailVC = self.childViewControllers[1] as? TopicDetailVC {
            detailVC.topic = meeting.topics[0]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
