//
//  TopicViewController.swift
//  BoardApp
//
//  Created by Rodrigo Chousal on 8/28/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit

class TopicDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var objectiveTextView: UITextView!
    @IBOutlet weak var discussionPointsTableView: UITableView!
    @IBOutlet weak var questionsTableView: UITableView!
    
    var topic: Topic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // FIXME: Background color of title view should be the same as topic color
        titleLabel.text = topic.title
        objectiveTextView.text = topic.objective
        
        discussionPointsTableView.delegate = self
        discussionPointsTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topic.pointsToDiscuss.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscussionPointCell", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = topic.pointsToDiscuss[indexPath.row].point
        cell.detailTextLabel?.text = topic.pointsToDiscuss[indexPath.row].point
        return cell
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
        print("Edit Title Pressed")
    }
    
    @IBAction func editObjectivePressed(_ sender: Any) {
        print("Edit Objective Pressed")
    }
    
    @IBAction func editDiscussionPointsPressed(_ sender: Any) {
        print("Edit Discussion Points Pressed")
    }
    
    @IBAction func closeVotingPressed(_ sender: Any) {
        print("Close Voting Pressed")
    }
    
    @IBAction func folderPressed(_ sender: Any) {
        print("Folder Icon Pressed")
    }
    
    @IBAction func attachmentsPressed(_ sender: Any) {
        print("Paperclip Icon Pressed")
    }
}
