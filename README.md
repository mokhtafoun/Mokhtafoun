# Mokhtafoun — Full Flutter + Firebase + Functions

- Multi-language (AR/FR/EN/ES)
- Anonymous Auth, Firestore, Storage, Analytics
- Admin approvals, Success stories, Rewards
- OG import, Audio upload, Police fields
- AI Functions (summarize/translate/moderate/ogimport/transcribe)

## Build Flutter Web (on CI or local)
flutter pub get
flutter build web

## Deploy Hosting (Console upload)
Upload `build/web` in Firebase Console → Hosting.

## Deploy Functions (AI) (CLI later)
cd functions && npm i && firebase deploy --only functions

## License
See `LICENSE.txt`. Non-commercial use only unless you obtain written permission from the Owner of Mokhtafoun app (contact: Mokhtafoun0@gmail.com).
