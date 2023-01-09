//
//  Injection.swift
//  notiTestLifecycle
//
//  Created by Hoang Do on 11/8/22.
//

import Resolver
import NotificationComponent

extension MyResolver: ResolverRegistering {
    public static func registerAllServices() {
        register { NotificationComponentImpl(enviroment: BuildConfig.enviroment, appGroupId: BuildConfig.appGroupId) as NotificationComponentProtocol }
            .scope(.cached)
    }
}
