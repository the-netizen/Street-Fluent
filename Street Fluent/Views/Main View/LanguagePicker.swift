import SwiftUI

struct LanguagePickerButton: View {
    var settings: AppSettings
    
    var body: some View {
        Menu {
            // only chinese for now
            ForEach(TargetLanguage.allCases.filter { $0 == .chinese }) { language in
                Button {
                    settings.selectedLanguage = language
                } label: {
                    HStack {
                        Text(language.flag)
                        if settings.selectedLanguage == language {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }//language selection
            
            // coming soon button
            Button {
                //
            } label: {
                HStack {
                    Text("Coming Soon")
                        .foregroundColor(.secondary)
                }
            }
            .disabled(true)
            
        } label: {
            // Flag
            HStack(spacing: 2) {
                Text(settings.selectedLanguage.flag)
                    .font(.title2)
                Image(systemName: "chevron.down")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    LanguagePickerButton(settings: AppSettings.shared)
}
