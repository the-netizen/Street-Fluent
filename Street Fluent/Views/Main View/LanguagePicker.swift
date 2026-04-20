import SwiftUI

struct LanguagePickerButton: View {
    var settings: AppSettings
    
    var body: some View {
        Menu {
            ForEach(TargetLanguage.allCases) { language in
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
            }
        } label: {
            // Flag only
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
