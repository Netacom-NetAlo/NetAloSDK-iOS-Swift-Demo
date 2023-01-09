//
//  BuildConfig.swift
//  NetAlo
//
//  Created by Tran Phong on 6/23/21.
//

import NetAloLite
import NetAloFull
import CloudKit

struct BuildConfig {
    static var config = NetaloConfiguration(
        enviroment: .production,
        appId: 10,
        appKey: "PS2zTS5$VyZccSaj",
        accountKey: "Gb6hC8BxmETdXXM",
        appGroupIdentifier: "group.hura.asia",
        storeUrl: URL(string: "https://apps.apple.com/vn/app/vndirect/id1594533471")!,
        deeplinkSchema: "hura",
        analytics: [],
        featureConfig: FeatureConfig(
            user: FeatureConfig.UserConfig(
                forceUpdateProfile: false,
                allowCustomUsername: false,
                allowCustomProfile: false,
                allowCustomAlert: false,
                allowAddContact: false,
                allowBlockContact: false,
                allowSetUserProfileUrl: false,
                allowEnableLocationFeature: false,
                allowTrackingUsingSDK: true,
                isHiddenEditProfile: true,
                allowAddNewContact: false
            ),
            chat: FeatureConfig.ChatConfig(
                isVideoCallEnable: true,
                isVoiceCallEnable: true,
                isHiddenSecretChat: true
            ),
            isSyncDataInApp: true,
            allowReferralCode: false,
            searchByLike: true,
            allowReplaceCountrycode: false,
            isSyncContactInApp: true
        ),
        permissions: [SDKPermissionSet.microPhone]
    )
}
