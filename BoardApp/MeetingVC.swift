//
//  MeetingVC.swift
//  BoardApp
//
//  Created by Rodrigo Chousal on 8/28/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit

class MeetingVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var bottomControlView: UIView!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var splitContentView: UIView!
    
    var meeting: Meeting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = meeting.title
        dateLabel.text = Date().description
        timeRemainingLabel.text = meeting.totalDuration.description
        statusLabel.text = "Por Comenzar" // FIXME: This should probably be a button at the beginning, so secretary can press "Empezar"
        
        
        setupProgressBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContainerSegue" {
            if let splitVC = segue.destination as? SplitVC {
                splitVC.meeting = self.meeting
            }
        }
    }
 
    // MARK: - Helper Methods
    
    func setupProgressBar() {
        var xOffset = CGFloat(0)
        for topic in meeting.topics {
            let relativeWidth = topic.duration/meeting.totalDuration
            let realWidth = progressBar.frame.width * CGFloat(relativeWidth)
            let topicBar = UIView(frame: CGRect(x: xOffset, y: 0, width: realWidth, height: progressBar.frame.height))
            topicBar.backgroundColor = topic.color
            topicBar.layer.cornerRadius = 4.0
            self.progressBar.addSubview(topicBar)
            xOffset += realWidth
        }
    }

    @IBAction func closeMeetingPressed(_ sender: Any) {
    }
    @IBAction func nextTopicPressed(_ sender: Any) {
    }
    @IBAction func pauseTopicPressed(_ sender: Any) {
    }
    @IBAction func finishTopicPressed(_ sender: Any) {
    }
}
