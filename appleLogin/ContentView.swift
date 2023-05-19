import SwiftUI
import AuthenticationServices

struct ContentView: View {
    @State private var userIdentifierTemp: String = ""
    
    var body: some View {
        VStack {
            SignInWithAppleButton(
                onRequest: { request in
                    // Handle the authorization request
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    // Handle the authorization completion
                    switch result {
                    case .success(let authResult):
                        // Handle the successful authorization
                        handleAuthorizationSuccess(authResult: authResult)
                    case .failure(let error):
                        // Handle the authorization failure
                        handleAuthorizationFailure(error: error)
                    }
                }
            )
            .frame(width: 200, height: 44)
            
            if userIdentifierTemp != "" {
                Text("userIdentifierTemp1 : \(userIdentifierTemp)")
            }
        }
        .onAppear {
            // Check credential state
            print("test")
            checkCredentialState()
        }
        .onReceive(NotificationCenter.default.publisher(for: ASAuthorizationAppleIDProvider.credentialRevokedNotification)) { _ in
            // 자격 증명 취소 알림 수신
            print("사용자 자격 증명이 취소되었습니다.")
        }
    }
    
    func handleAuthorizationSuccess(authResult: ASAuthorization) {
        if let appleIDCredential = authResult.credential as? ASAuthorizationAppleIDCredential {
            // Handle Apple ID credential
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // Perform necessary actions with the credential data
            // ...
            userIdentifierTemp = userIdentifier
            print("인증성공 후 호출")
            print("userIdentifier : \(userIdentifier)")
            print("fullName : \(String(describing: fullName))")
            print("email : \(String(describing: email))")
        }
    }
    
    func handleAuthorizationFailure(error: Error) {
        // Handle authorization error
        print("인증 실패: \(error.localizedDescription)")
    }
    
    func checkCredentialState() {
        let provider = ASAuthorizationAppleIDProvider()//000787.090a07c989b4464f933df0566cb842a5.0805 김준태 000609.8daa3fe7269a418caf7684fab451f31c.0304 조예주
        provider.getCredentialState(forUserID: "000787.090a07c989b4464f933df0566cb842a5.0805") { credentialState, error in
            if let error = error {
                // Error checking credential state
                print("Error checking credential state: \(error.localizedDescription)")
                return
            }
            
            switch credentialState {
            case .authorized:
                // User credential is authorized
                print("User credential is authorized")
            case .revoked:
                // User credential is revoked
                print("User credential is revoked")
            case .notFound:
                // User credential not found
                print("User credential not found")
            default:
                break
            }
        }
    }

}
