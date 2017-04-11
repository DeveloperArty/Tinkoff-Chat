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
    fileprivate let discoveryInfo = [ "userName" : "your mom" ]
    // advertiser & browser
    var advertiser: MCNearbyServiceAdvertiser!
    var browser: MCNearbyServiceBrowser!
    
    // Meths
    init(delegate: CommunicatorDelegate) {
        self.delegate = delegate
    }
    
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
        let session = self.getSession(forUserWith: peerID)
        if !session.connectedPeers.contains(peerID) {
            browser.invitePeer(peerID,
                               to: session,
                               withContext: nil,
                               timeout: 30)
        }
    }
}


// MARK: - Session Delegate 
extension MultipeerCommunicator: MCSessionDelegate {
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print(#function)
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
