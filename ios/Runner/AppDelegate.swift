import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      // Override point for customization after application launch.

        //############################################################## AppSealing Code-Part BEGIN: DO NOT MODIFY THIS LINE !!!
        let inst: AppSealingInterface = AppSealingInterface();
        let tamper: Int32 = inst._IsAbnormalEnvironmentDetected();
        if ( tamper > 0 )
        {
            var msg = "Abnormal Environment Detected !!";
            if ( tamper & DETECTED_JAILBROKEN ) > 0
                { msg += "\n - Jailbroken"; }
            if ( tamper & DETECTED_DRM_DECRYPTED ) > 0
                { msg += "\n - Executable is not encrypted"; }
            if ( tamper & DETECTED_DEBUG_ATTACHED ) > 0
                { msg += "\n - App is debugged"; }
            if ( tamper & ( DETECTED_HASH_INFO_CORRUPTED | DETECTED_HASH_MODIFIED )) > 0
                { msg += "\n - App integrity corrupted"; }
            if ( tamper & ( DETECTED_CODESIGN_CORRUPTED | DETECTED_EXECUTABLE_CORRUPTED )) > 0
                { msg += "\n - App executable has corrupted"; }
            if ( tamper & DETECTED_CERTIFICATE_CHANGED ) > 0
                { msg += "\n - App has re-signed"; }
            if ( tamper & DETECTED_BLACKLIST_CORRUPTED ) > 0
                { msg += "\n - Blacklist/Whitelist has corrupted or missing"; }
            if ( tamper & DETECTED_CHEAT_TOOL ) > 0
                { msg += "\n - Cheat tool has detected"; }

            let alertController = UIAlertController(title: "AppSealing", message: msg, preferredStyle: .alert );
            alertController.addAction(UIAlertAction(title: "Confirm", style: .default,
                                    handler: { (action:UIAlertAction!) -> Void in
                                #if !DEBUG   // Debug mode does not kill app even if security threat has found
                                        exit(0);
                                #endif
                                    } ));
            DispatchQueue.main.async {
                self.window?.rootViewController?.present( alertController, animated: true, completion: nil)
            };
        }

        AppSealingInterface._NotifySwizzlingDetected( { (msg: String?) -> () in
            let alertController = UIAlertController( title: "AppSealing Security", message: msg, preferredStyle: .alert );
            alertController.addAction( UIAlertAction( title: "Confirm", style: .default,
                                                        handler: { ( action:UIAlertAction! ) -> Void in
    #if DEBUG
    #else
                exit(0);
    #endif
            } ));
            
            DispatchQueue.main.async {
                self.window?.rootViewController?.present( alertController, animated: true, completion: nil )
            };
        });

        //############################################################## AppSealing Code-Part END: DO NOT MODIFY THIS LINE !!!

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
