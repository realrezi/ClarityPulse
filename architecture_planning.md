# Technical Architecture & Planning Document
## ClarityPulse: Cognitive Wellness App

### 1. Overview
An iOS mobile app providing gentle cognitive stimulation exercises and relaxing mindfulness content under the core guiding motto: **"Clear the fog. Return to your best self."**
**Core Mission:** Provide accessible, non-frustrating cognitive exercises paired with stress-reduction elements, entirely processed locally on the device for maximum privacy.

### 2. Technology Stack & Configuration
*   **Target Platform:** iOS 17.0+ 
*   **App Store Category:** MUST be set to "Lifestyle" or "Education". Do NOT use "Health & Fitness".
*   **Local Storage:** SwiftData (for tracking user progression locally).
*   **Visuals & UI:** SwiftUI, SF Symbols (strictly native symbols ONLY to ensure near-zero memory footprint).
*   **Frameworks:** StoreKit 2, SwiftUI Sensory Feedback, Swift Charts (for progression visualization), UserNotifications.

### 3. Core Features & Navigation
1.  **Home Screen (The "Calm" Center):**
    *   Displays the core motto (*"Clear the fog. Return to your best self."*) alongside a daily relaxing quote loaded asynchronously from a bundled JSON file.
    *   Background: Linear gradient from `#DCEBDE` (top) to `#E1EBF5` (bottom). Text in `#2C3E50`.
2.  **Exercise Module (Adaptive & Hardware-Synced):**
    *   Hosts the cognitive tasks (e.g., N-Back).
    *   *CRITICAL:* Reaction times must be calculated using `DispatchTime.now().uptimeNanoseconds` to avoid main-thread UI lag and ensure scientific precision.
    *   *Rule:* Difficulty automatically scales down if accuracy drops below 60%.
3.  **Progress Visualization:**
    *   A dashboard utilizing Swift Charts to graph consistency and gentle progression.
4.  **Accessibility (Mandatory):**
    *   100% support for Dynamic Type text scaling and high-contrast styling.

### 4. STRICT Regulatory Compliance Strategy 
*   **Banned Terms:** Treatment, therapy, cure, chemo brain, patient, diagnose, clinical, recovery.
*   **2026 AI Transparency:** All quotes are pre-generated offline via AI and bundled as a JSON asset.
*   **Required Onboarding Disclaimer:** Must state: *"This app is designed for educational and wellness purposes only and is not intended to diagnose, treat, or cure any medical condition. Our daily wellness quotes are curated offline using AI to ensure a calming experience. No personal data ever leaves your device."*