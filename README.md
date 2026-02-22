# CARE-AI Demo

Swift/SwiftUI iOS 17+ prototype for CARE-AI Phase 1 scope with MVVM + async/await and **Demo Mode ON by default**.

## What is included
- Onboarding/consent flow (demo eConsent)
- Connect Health System screen with Demo FHIR connection + fake SMART token saved via keychain abstraction
- Home tab app shell: SCD, Aortic, Coach, Community (stub), Settings
- SCD dashboard with:
  - Pain trend (14-day mock)
  - Fever log with add entry
  - SpO2 trend (mock health provider)
  - Acute care visit count (mock)
  - Hb + retic trend values (mock)
  - Fever pathway urgent logic (red card when fever >= 38.3 C OR SpO2 < 92 OR chest symptoms ON)
- Aortic dashboard stub with BP trend, imaging timeline, and adherence toggles
- AI Coach with deterministic local responder + context panel toggles
- Sharing flow: export demo data as FHIR Bundle JSON preview
- Audit log viewer (consent, connect, dashboard view, export, AI interactions)
- `SpeziIntegration/` adapter placeholder + TODOs for future Spezi modules

All patient/health data is mocked and for demo only.

## Project structure
- `CAREAIDemo/` contains iOS app source organized by module:
  - `Core`, `Auth`, `FHIRClient`, `HealthData`, `PGHD`, `SCDModule`, `AorticModule`, `AICoach`, `Sharing`, `AuditLog`, `SpeziIntegration`
- `Sources/CAREAIDemoCore` has shared pure-Swift core logic used by tests
- `Tests/CAREAIDemoCoreTests` unit tests for decision logic + bundle export

## Prerequisites
- Xcode 15.0+ (recommended latest)
- iOS Simulator runtime for iOS 17+

## Open and run in Xcode Simulator
1. Open Xcode.
2. Create a new **iOS App** project named `CARE-AI Demo` (SwiftUI lifecycle).
3. Replace generated app source with files from `CAREAIDemo/` in this repo.
4. Ensure deployment target is iOS 17+.
5. Build and run on an iPhone Simulator.

> Note: The app source is fully organized and ready to drop into an iOS app target. This repository also includes a Swift package (`CAREAIDemoCore`) for testable domain logic.

## Run unit tests
From repository root:

```bash
swift test
```

## Demo Mode
- Demo Mode is ON by default in `AppState`.
- You can also toggle it in **Settings** tab.

## Trigger the SCD urgent alert
1. Launch app and accept consent.
2. Connect to **Demo FHIR Server**.
3. Go to **SCD** tab.
4. Either:
   - Add fever `38.3` or higher, OR
   - Enable `New chest symptoms`, OR
   - Use low SpO2 mock data (<92).
5. Red urgent card appears with ED guidance.

## Export data + view audit log
- Open **Settings** tab.
- Tap **Export My Data** to preview generated FHIR Bundle JSON.
- Tap **View Audit Log** to see append-only local events.

## Important disclaimer
Visible on relevant screens:

> Not medical advice. For emergencies call 911.
