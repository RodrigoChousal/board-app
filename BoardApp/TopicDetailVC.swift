//
//  TopicViewController.swift
//  BoardApp
//
//  Created by Rodrigo Chousal on 8/28/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit

class TopicDetailVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var objectiveTextView: UITextView!
    @IBOutlet weak var discussionPointsTableView: UITableView!
    @IBOutlet weak var questionsTableView: UITableView!
    
    var topic: Topic = Topic(title: "", objective: "", pointsToDiscuss: [DiscussionPoint(point: "")], duration: TimeInterval(exactly: 2)!)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func editTitlePressed(_ sender: Any) {
    }
    
    @IBAction func editObjectivePressed(_ sender: Any) {
    }
    
    @IBAction func editDiscussionPointsPressed(_ sender: Any) {
    }
    
    @IBAction func closeVotingPressed(_ sender: Any) {
    }
    
    @IBAction func folderPressed(_ sender: Any) {
    }
    
    @IBAction func attachmentsPressed(_ sender: Any) {
    }
}
