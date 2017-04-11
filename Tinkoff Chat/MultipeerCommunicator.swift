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
    var online: Bool = false
    var sessions = [MCPeerID: MCSession]()
    
    // mc main settings
    fileprivate let myPeerID = MCPeerID(displayName: "arty.pablo")
    fileprivate let serviceType: String = "tinkoff-chat"
    fileprivate let discoveryInfo = [ "userName" : "Yo bro" ]
    // advertiser & browser
    var advertiser: MCNearbyServiceAdvertiser!
    var browser: MCNearbyServiceBrowser!
    
    func sendMessage(string: String,
                     to userID: String,
                     completionHandler: ((_ success: Bool, _ error: Error?) -> Void)? ) {
        
    }
    
    func start() {
        print(#function)
        
        self.advertiser = MCNearbyServiceAdvertiser(peer: myPeerID,
                                                    discoveryInfo: discoveryInfo,
                                                    serviceType: serviceType)
        self.browser = MCNearbyServiceBrowser(peer: myPeerID,
                                              serviceType: serviceType)
        advertiser.delegate = self
        browser.delegate = self
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    fileprivate func getSession(forUserWith peerID: MCPeerID) -> MCSession {
        if let session = self.sessions[peerID] {
            print("session found")
            return session
        } else {
            print("session created")
            let newSession = MCSession(peer: myPeerID,
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
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(#function)
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print(discoveryInfo)
        
        if let name = discoveryInfo["userName"] {
            let session = self.getSession(forUserWith: peerID)
            if !session.connectedPeers.contains(peerID) {
                browser.invitePeer(peerID,
                                   to: session,
                                   withContext: nil,
                                   timeout: 30)
            }
            delegate?.didFoundUser(userID: peerID.displayName, userName: name)
        }
    }
}


// MARK: - Session Delegate 
extension MultipeerCommunicator: MCSessionDelegate {
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print(#function)
        
        do {
            let message = try JSONSerialization.jsonObject(with: data, options: [])
            print(message)
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
            
            if let message = generateMessage(text: "sdjndkjgnkjdf") {
                do {
                    try session.send(message, toPeers: [peerID], with: .unreliable)
                } catch {
                    print(error.localizedDescription)
                }
            }
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
