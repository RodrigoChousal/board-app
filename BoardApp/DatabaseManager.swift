//
//  DatabaseManager.swift
//  BoardApp
//
//  Created by Rodrigo Chousal on 8/29/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import Foundation
import UIKit

class DatabaseManager {
    
    // FIXME: Good time to learn proper error handling
    
    // MARK: - Writing Data
    
    static func addUser(user: User) {
//		var ref: DocumentReference? = nil
//		ref = Global.usersCollectionRef.addDocument(data: ["firstName" : user.firstName,
//														   "lastName" : user.lastName,
//														   "email" : user.email,
//														   "meetingsIDs" : user.meetingsIdList]) { (error) in // TODO: Upcoming meetings and past meetings
//			if let err = error {
//				print("User addition failed with error: " + err.localizedDescription)
//			} else {
//				print("User added with ID: \(ref!.documentID)")
//			}
//		}
    }
    
    static func addMeeting(meeting: Meeting) {
//		var ref: DocumentReference? = nil
//		ref = Global.meetingsCollectionRef.addDocument(data: ["title" : meeting.title,
//															  "participants" : meeting.participantIdList,
//															  "topics" : meeting.topicsList,
//															  "locationID" : meeting.location.uniqueID,
//															  "timeDate" : meeting.timeDate.description,
//															  "totalDuration" : meeting.totalDuration,
//															  "fileCount" : meeting.fileCount]) { (error) in
//			if let err = error {
//				print("Meeting addition failed with error: " + err.localizedDescription)
//			} else {
//				print("Meeting added with ID: \(ref!.documentID)")
//			}
//		}
    }
	
	// MARK: - Custom-to-Native
	
//	static func uploadableTopics(fromArray topicsArray: [Topic]) -> NSArray {
//		
//	}
	
    // MARK: - Reading Data
    
    // MARK: - String-to-String
    
    static func validTitle(fromString titleString: String) -> String {
        if !titleString.isEmpty {
            return titleString
        } else {
            print("ERROR! Title was not valid, returned error value: InvalidTitle")
            return "InvalidTitle"
        }
    }
    
    static func validObjective(fromString objectiveString: String) -> String {
        if !objectiveString.isEmpty {
            return objectiveString
        } else {
            print("ERROR! Objective was not valid, returned error value: InvalidObjective")
            return "InvalidObjective"
        }
    }
    
    // MARK: - String-to-Native Class
    
    static func validDate(fromString dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        if let date = dateFormatter.date(from: dateString)  {
            return date
        } else {
            print("ERROR! Date was not valid, returned error value: " + Date().description)
            return Date()
        }
    }
    
    static func validColor(fromString colorString: String) -> UIColor {
        if let validColor = UIColor(named: colorString) {
            return validColor
        } else {
            print("ERROR! Color was not valid, returned error value: Black")
            return UIColor.black
        }
    }
    
    static func validDuration(fromString durationString: String) -> TimeInterval {
        if let number = Double(durationString) {
            return TimeInterval(number)
        } else {
            print("ERROR! Duration was not valid, returned error value: 0 seconds")
            return TimeInterval(0)
        }
    }
    
    // MARK: - String-to-Custom Class
    
    static func validRole(fromString roleString: String) -> User.Role {
        if let role = User.Role(rawValue: roleString) {
            return role
        } else {
            print("ERROR! Role was not valid, returned error value: DESCONOCIDO")
            return User.Role.desconocido
        }
    }
    
    static func validLocation(fromString locString: String) -> Location {
        if let name = Location.ValidName(rawValue: locString) {
            let location = Location(uniqueID: "id", name: name)
            return location
        } else {
            print("ERROR! Location was not valid, returned default value: DESCONOCIDA")
            return Location(uniqueID: "id", name: Location.ValidName.desconocida)
        }
    }
    
    // MARK: - Native-to-Custom Class
    
    // FIXME: Database should return an array of User IDs and this method should search...
    static func validParticipants(fromDictionary participantDictionary: NSDictionary) -> [User.Role : User] {
        var participants = [User.Role : User]()
        for (role, user) in participantDictionary {
            let validRole = self.validRole(fromString: role as? String ?? "")
			let validUser = self.validUser(fromDictionary:  user as? NSDictionary ?? NSDictionary())
            participants[validRole] = validUser //FIXME: Could prove faulty because of dual roles
        }
        return participants
    }
    
    static func validDiscussionPoints(fromArray pointsArray: NSArray) -> [DiscussionPoint] {
        var validPoints = [DiscussionPoint]()
        for point in pointsArray {
            if let pointDictionary = point as? NSDictionary {
                let validPoint = DiscussionPoint(point: pointDictionary.value(forKey: "point") as? String ?? "Invalid Point")
                validPoints.append(validPoint)
            } else {
                print("ERROR! Discussion Point was not valid, returned default value: InvalidPoint")
                validPoints.append(DiscussionPoint(point: "InvalidPoint"))
            }
        }
        return validPoints
    }
    
    static func validTopics(fromArray topicsArray: NSArray) -> [Topic] {
        var validTopics = [Topic]()
        for topic in topicsArray {
            if let topicDictionary = topic as? NSDictionary {
                let color = validColor(fromString: topicDictionary.value(forKey: "color") as? String ?? "InvalidColor")
                let title = validTitle(fromString: topicDictionary.value(forKey: "title") as? String ?? "InvalidTitle")
                let objective = validObjective(fromString: topicDictionary.value(forKey: "objective") as? String ?? "InvalidObjective")
                let discussionPoints = validDiscussionPoints(fromArray: topicDictionary.value(forKey: "discussionPoints") as? NSArray ?? NSArray())
                let duration = validDuration(fromString: topicDictionary.value(forKey: "duration") as? String ?? "InvalidDuration")
				let responsible = validUser(fromDictionary: topicDictionary.value(forKey: "responsible") as?  NSDictionary ?? NSDictionary())
                let validTopic = Topic(color: color, title: title, responsible: responsible, objective: objective, pointsToDiscuss: discussionPoints, duration: duration)
                validTopics.append(validTopic)
            } else {
                print("ERROR! Topic was not valid, did not return a value")
            }
        }
        return validTopics
    }
	
	static func validMeetings(fromArray meetingsArray: NSArray) -> [Meeting] {
		var validMeetings = [Meeting]()
		for meeting in meetingsArray {
			if let meetingDictionary = meeting as? NSDictionary {
				print("Transcribing meeting...")
				let meetingID = "an id"
				let title = DatabaseManager.validTitle(fromString: meetingDictionary.value(forKey: "title") as? String ?? "")
				let timeDate = DatabaseManager.validDate(fromString: meetingDictionary.value(forKey: "timeDate") as? String ?? "")
				let participants = DatabaseManager.validParticipants(fromDictionary: meetingDictionary.value(forKey: "participants") as? NSDictionary ?? NSDictionary())
				let topics = DatabaseManager.validTopics(fromArray: meetingDictionary.value(forKey: "topics") as? NSArray ?? NSArray())
				let location = DatabaseManager.validLocation(fromString: meetingDictionary.value(forKey: "location") as? String ?? "")
				let meeting = Meeting(uniqueID: meetingID, title: title, timeDate: timeDate, participants: participants, topics: topics, location: location)
				validMeetings.append(meeting)
			} else {
				print("ERROR! Meeting was not valid, did not return a value")
			}
		}
		return validMeetings
	}
    
    static func validUser(fromDictionary userDictionary: NSDictionary) -> User {
        let email = userDictionary["email"] as? String ?? ""
        let firstName = userDictionary["firstName"] as? String ?? ""
        let lastName = userDictionary["lastName"] as? String ?? ""
        let meetingIDs = userDictionary["meetings"] as? [String] ?? [String]()
        let localUser = User(email: email,
                            firstName: firstName,
                            lastName: lastName,
                            meetingsIdList: meetingIDs)
		print("Populated meeting IDs locally")
        return localUser
    }
}
