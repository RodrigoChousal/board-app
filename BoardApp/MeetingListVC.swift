//
//  MeetingListVC.swift
//  BoardApp
//
//  Created by Rodrigo Chousal on 8/28/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit
import FirebaseAuth

class MeetingListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var meetingTableView: UITableView!
	var meetings: [Meeting] = [Meeting]()
	
	override func viewWillAppear(_ animated: Bool) {
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if Global.localUser.meetingsIdList.count > 1 {
			fetchUserMeetings {
				print("Reloaded data")
				self.meetingTableView.reloadData()
			}
		} else {
			// Fill table view with "No meetings in near future"
		}
		
		meetingTableView.delegate = self
        meetingTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.meetings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingCell", for: indexPath) as! MeetingTVCell
		if self.meetings.count != 0 {
			let meeting = self.meetings[indexPath.row]
			cell.titleLabel.text = meeting.title
			cell.timeDateLabel.text = meeting.timeDate.description
			cell.participantsLabel.text = meeting.participantList
			cell.topicsLabel.text = meeting.topicList
			cell.durationLabel.text = meeting.totalDuration.description
			cell.fileCountLabel.text = meeting.fileCount.description
		}
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "MeetingSegue" {
            let meetingVC = segue.destination as! MeetingVC
            if let selectedRow = self.meetingTableView.indexPathForSelectedRow?.row {
				if let meetings = Global.localUser.meetings {
					meetingVC.meeting = meetings[selectedRow]
					
				}
            }
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func showPastMeetings(_ sender: Any) {
        
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
		view.showLoadingIndicator(withMessage: "Cerrando sesión...")
        if let _ = try? Auth.auth().signOut(), let _ = try? KeychainManager.deleteCredentials(credentials: KeychainManager.fetchCredentials()) {
            self.dismiss(animated: true) {
				self.view.stopLoadingIndicator()
                print("Deleted local credentials, user signed out, and dismissed view controller")
            }
        } else {
			self.view.stopLoadingIndicator()
            print("There was an error signing out!")
        }
    }
    
    // MARK: - Helper Methods
	
	func fetchUserMeetings(completion: @escaping () -> Void) {
		var meetingsRawArray = NSArray()
		var count = 0
		for meetingID in Global.localUser.meetingsIdList {
			count += 1
			Global.meetingsCollectionRef.document(meetingID).getDocument { (document, error) in
				print("Fetching a meeting...")
				if let document = document, document.exists {
					if let meetingDictionary = document.data()! as NSDictionary? {
						meetingsRawArray = NSArray(array: meetingsRawArray.adding(meetingDictionary))
						print("Validating meetings from raw array...")
						self.meetings = DatabaseManager.validMeetings(fromArray: meetingsRawArray)
						if count == Global.localUser.meetingsIdList.count {
							completion()
						}
					} else {
						print("ERROR: Invalid meeting dictionary fetched from Firestore")
					}
				} else {
					print("Document with that MeetingID does not exist")
				}
			}
		}
	}
    
//    func generateTestMeeting() -> Meeting {
//
//        let person1 = User(firstName: "Jesús", lastName: "Parás")
//        let person2 = User(firstName: "Roberto", lastName: "Marcos")
//        let person3 = User(firstName: "Manuel", lastName: "Doblado")
//        let person4 = User(firstName: "Alfredo", lastName: "Peña")
//        let participants = [User.Role.administrador : person1, User.Role.consejero : person2, User.Role.secretario : person3, User.Role.presidente : person4]
//
//        let duration1 = TimeInterval(exactly: 30)
//        let topic1 = Topic(color: UIColor.red, title: "Tema 1", responsible: person4, objective: "Objetivo del tema", pointsToDiscuss: [DiscussionPoint(point: "Punto 1"),
//                                                                                                                                        DiscussionPoint(point: "Punto 2"),
//                                                                                                                                        DiscussionPoint(point: "Punto 3"),
//                                                                                                                                        DiscussionPoint(point: "Punto 4")], duration: duration1!)
//
//        let duration2 = TimeInterval(exactly: 25)
//        let topic2 = Topic(color: UIColor.gray, title: "Tema 2", responsible: person3, objective: "Objetivo del tema 2", pointsToDiscuss: [DiscussionPoint(point: "Punto 5"),
//                                                                                                                                           DiscussionPoint(point: "Punto 6"),
//                                                                                                                                           DiscussionPoint(point: "Punto 7"),
//                                                                                                                                           DiscussionPoint(point: "Punto 8")], duration: duration2!)
//        let duration3 = TimeInterval(exactly: 290)
//        let topic3 = Topic(color: UIColor.brown, title: "Tema 3", responsible: person1, objective: "Objetivo del tema 3", pointsToDiscuss: [DiscussionPoint(point: "Punto 9"),
//                                                                                                                                            DiscussionPoint(point: "Punto 10"),
//                                                                                                                                            DiscussionPoint(point: "Punto 11"),
//                                                                                                                                            DiscussionPoint(point: "Punto 12")], duration: duration3!)
//        let topics = [topic1, topic2, topic3]
//
//        let location = Location(name: Location.ValidName.sala1)
//
//        return Meeting(title: "Test Meeting", timeDate: Date(), participants: participants, topics: topics, location: location)
//    }
}
