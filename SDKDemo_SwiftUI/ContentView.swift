//
//  ContentView.swift
//  SDKDemo_SwiftUI
//
//  Created by Hoang Do on 1/9/23.
//

import SwiftUI
import RxSwift
import NADomain
import NetAloFull
import NATheme
import Resolver

struct ContentView: View {
    var delegate: AppDelegate

    var body: some View {
        VStack {
            Button("Show Demo") {
                self.delegate.netAloSDK.showVNDemoVC()
            }
            Spacer()
            Button("Show Listgroup") {
                self.delegate.netAloSDK.showListGroup { error in
                    let err = error as? NAError
                    print("showVNDemoVC with err: \(err?.description ?? "")")
                }
            }
            Spacer()
            Button("show group chat") {
                self.delegate.netAloSDK.showGroupChat(with: "2915961526638025", completion: { error in
                    let err = error as? NAError
                    print("showGroupChat with err: \(err?.description ?? "")")
                })
            }
            Spacer()
            Button("Personal call") {
                let testContact = NAContact(id: 4785074606744072, phone: "rooney", fullName: "rooney", profileUrl: "")
                self.delegate.netAloSDK.showCall(with: testContact, isVideoCall: false, completion: { error in
                    let err = error as? NAError
                    print("showCall with1 err: \(err?.description ?? "")")
                })
            }

        }
        .padding()
    }
}
