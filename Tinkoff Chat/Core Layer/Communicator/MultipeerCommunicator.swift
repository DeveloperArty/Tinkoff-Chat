//
//  MultipeerCommunicator.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 10.04.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator {
    
    // Properties
    weak var delegate: CommunicatorDelegate?
    var online: Bool = false {
        willSet {
            if newValue == true {
                advertiser?.startAdvertisingPeer()
                browser?.startBrowsingForPeers()
            } else {
                advertiser?.stopAdvertisingPeer()
                browser?.stopBrowsingForPeers()
            }
        }
    }
    var sessions = [MCPeerID: MCSession]()
    var userIDs = [String: MCPeerID]()
    
    // mc main settings
    private var _myPeerID: MCPeerID?
    fileprivate var myPeerID: MCPeerID? {
        get {
            if _myPeerID == nil {
                _myPeerID = MCPeerID(displayName: "arty.pablo")
            }
            return _myPeerID
        }
    }
    fileprivate let serviceType: String = "tinkoff-chat"
    fileprivate let discoveryInfo = [ "userName" : "Pablo" ]
    
    // advertiser & browser
    private var _advertiser: MCNearbyServiceAdvertiser?
    private var advertiser: MCNearbyServiceAdvertiser? {
        get {
            if _advertiser == nil {
                guard let peer = myPeerID else {
                    print("no peer")
                    return nil
                }
                _advertiser = MCNearbyServiceAdvertiser(peer: peer,
                                                        discoveryInfo: discoveryInfo,
                                                        serviceType: serviceType)
                _advertiser?.delegate = self
                _advertiser?.startAdvertisingPeer()
            }
            return _advertiser
        }
    }
    
    private var _browser: MCNearbyServiceBrowser?
    private var browser: MCNearbyServiceBrowser? {
        get {
            if _browser == nil {
                guard let peer = myPeerID else {
                    print("no peer")
                    return nil
                }
                _browser = MCNearbyServiceBrowser(peer: peer,
                                                  serviceType: serviceType)
                _browser?.delegate = self
                _browser?.startBrowsingForPeers()
            }
            return _browser
        }
    }
    
    func sendMessage(string: String,
                     to userID: String,
                     completionHandler: ((_ success: Bool, _ error: Error?) -> Void)? ) {
        let peerID = userIDs[userID]!
        if let session = sessions[peerID] {
            if let message = generateMessage(text: string) {
                do {
                    try session.send(message, toPeers: [peerID], with: .unreliable)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    fileprivate func getSession(forUserWith peerID: MCPeerID) -> MCSession {
        if let session = self.sessions[peerID] {
            print("session found")
            return session
        } else {
            print("session created")
            let newSession = MCSession(peer: myPeerID!,
                                       securityIdentity: nil,
                                       encryptionPreference: .none)
            newSession.delegate = self
            sessions[peerID] = newSession
            return newSession
        }
    }
    
    fileprivate func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    fileprivate func generateMessage(text: String) -> Data? {
        let dict = ["eventType" : "TextMessage", "messageId" : generateMessageId(), "text": text]
        do {
            let json = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            return json
        } catch  {
            print(error.localizedDescription)
            return nil
        }
    }
}


// MARK: - Advertiser Delegate
extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
        print(#function)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print(#function)
        let session = getSession(forUserWith: peerID)
        let accept = !session.connectedPeers.contains(peerID)
        invitationHandler(accept, session)
        return 
    }
}


// MARK: - Browser Delegate 
extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print(#function)
        delegate?.didLostUser(userID: peerID.displayName)
        sessions[peerID] = nil
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(#function)
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        if let name = info?["userName"] {
            print(name)
            let session = self.getSession(forUserWith: peerID)
            if !session.connectedPeers.contains(peerID) {
                browser.invitePeer(peerID,
                                   to: session,
                                   withContext: nil,
                                   timeout: 30)
            }
            let userid = peerID.displayName
            delegate?.didFoundUser(userID: userid, userName: name)
            userIDs[userid] = peerID
        }
    }
}


// MARK: - Session Delegate 
extension MultipeerCommunicator: MCSessionDelegate {
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print(#function)
        
        do {
            if let message = try JSONSerialization.jsonObject(with: data,
                                                              options: []) as? [String: String] {
                if message["eventType"] == "TextMessage" {
                    if let text = message["text"] {
                        delegate?.didReceiveMessage(text: text,
                                                    fromUser: peerID.displayName,
                                                    toUser: (myPeerID?.displayName)!)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print(#function)
        print(state.rawValue)
        
        switch state {
        case .connecting:
            print("connecting")
        case .connected:
            print("connected!")
        default:
            print("oh shit")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print(#function)
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print(#function)
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        print(#function)
    }
}
