import SwiftUI

struct ProfileButton: View {
    @State private var showMenu = false
    
    var body: some View {
        Menu {
            Button {
                //sign in
            } label: {
                Label("Sign in with Apple ID", systemImage: "apple.logo")
            }
            
            Divider()
//            
//            Button {
//                //sign out
//            } label: {
//                Text("Sign out")
//            }
        } label: {
            Image(systemName: "person.crop.circle")
                .font(.caption2)
                .foregroundColor(.primary)
        }
        
    }
}

#Preview {
    ProfileButton()
}
