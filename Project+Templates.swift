import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    
    private static let organizationName = "ofo.io"
    private static let iOSTargetVersion = "16.0"
    
    /// Helper function to create the Project for this ExampleApp
    public static func app(
        name: String,
        platform: Platform,
        iOSTargetVersion: String,
        infoPlist: InfoPlist = .default,
        dependencies: [TargetDependency] = []
    ) -> Project {
        let targets = makeAppTargets(name: name,
                                     platform: platform,
                                     iOSTargetVersion: iOSTargetVersion,
                                     infoPlist: infoPlist,
                                     dependencies: dependencies)
        return Project(name: name,
                       organizationName: organizationName,
                       targets: targets)
    }
    
    public static func makeApp(
        name: String,
        platform: Platform,
        iOSTargetVersion: String,
        infoPlist: [String: InfoPlist.Value] = [:],
        dependencies: [TargetDependency] = []
    )
    -> Project
    {
        var targets = makeFrameworkTargets(name: name,
                                           platform: platform,
                                           iOSTargetVersion: iOSTargetVersion,
                                           dependencies: dependencies)
        targets.append(contentsOf: makeAppTargets(name: "\(name)DemoApp",
                                                  platform: platform,
                                                  iOSTargetVersion: iOSTargetVersion,
                                                  dependencies: [.target(name: name)]))
        return Project(name: name,
                       organizationName: organizationName,
                       targets: targets)
    }
    
    public static func makeFramework(
        name: String,
        platform: Platform,
        iOSTargetVersion: String,
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency] = [])
    -> Project
    {
        let targets = makeFrameworkTargets(name: name,
                                           platform: platform,
                                           iOSTargetVersion: iOSTargetVersion,
                                           dependencies: dependencies)
        return Project(name: name,
                       organizationName: organizationName,
                       targets: targets)
    }
    
    // MARK: - Private
    
    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(
        name: String,
        platform: Platform,
        iOSTargetVersion: String,
        dependencies: [TargetDependency])
    -> [Target]
    {
        let sources = Target(name: name,
                             platform: platform,
                             product: .framework,
                             bundleId: "ofo.io.\(name)",
                             deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: .iphone),
                             infoPlist: .default,
                             sources: ["Sources/**"],
                             resources: [],
                             dependencies: dependencies)
        
        let tests = Target(name: "\(name)Tests",
                           platform: platform,
                           product: .unitTests,
                           bundleId: "ofo.io.\(name)Tests",
                           infoPlist: .default,
                           sources: ["Tests/**"],
                           resources: [],
                           dependencies: [.target(name: name)])
        return [sources, tests]
    }
    
    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(
        name: String,
        platform: Platform,
        iOSTargetVersion: String,
        infoPlist: InfoPlist = .default,
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency])
    -> [Target]
    {
        //        let platform: Platform = platform
        //        let infoPlist: [String: InfoPlist.Value] = [
        //            "CFBundleShortVersionString": "1.0",
        //            "CFBundleVersion": "1",
        //            "UIMainStoryboardFile": "",
        //            "UILaunchStoryboardName": "LaunchScreen"
        //        ]
        
        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "ofo.io.\(name)",
            deploymentTarget: .iOS(targetVersion: iOSTargetVersion, devices: .iphone),
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            dependencies: dependencies
        )
        
        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "ofo.io.\(name)Tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "\(name)")
            ])
        return [mainTarget, testTarget]
    }
}
