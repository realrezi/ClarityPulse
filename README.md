# ClarityPulse

![iOS](https://img.shields.io/badge/iOS-17.0%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![Framework](https://img.shields.io/badge/Framework-SwiftUI%20%7C%20SwiftData-teal)
![License](https://img.shields.io/badge/License-MIT-green)

**Clear the fog. Return to your best self.**

ClarityPulse is a clinical-grade, native iOS application designed to quantify cognitive performance and track mental fatigue. Through precise psychometric assessments, it acts as a personal cognitive dashboard to measure speed, accuracy, and baseline fluctuations over time.

*Designed and Engineered by Ahmadreza Shirdel, MD*

---

## 🧠 Core Architecture & SwiftData Schema

ClarityPulse is built on a robust, locally persisted `SwiftData` schema designed for longitudinal tracking and future data science workflows (e.g., CSV ingestion into Python/R for epidemiological or machine learning analysis).

The system revolves around three core `@Model` classes:
1. **`UserSession`**: The overarching wrapper for daily cognitive assessments. It tracks global metrics and timestamps to establish longitudinal baselines.
2. **`ExerciseResult`**: The core psychometric data node. It strictly records cognitive velocity (Reaction Time in ms) and precision (Accuracy %), mapping the granular results of each cognitive stress test (N-Back, Stroop) directly to the overarching session and the user's active behavioral interventions.
3. **`MicroTrial`**: The engine of the N-of-1 trial architecture. It tracks active A/B testing protocols (e.g., Tag A vs. Tag B) and bridges `ExerciseResult` data to compute the clinical deltas between distinct behavioral states.

---

## 🔬 Phase 2: N-of-1 Micro-Trials & Delta Engine

ClarityPulse transcends basic data logging by integrating a true **Micro-Trial Engine** that empowers users to conduct strict 7-day N-of-1 behavioral experiments. 

- **A/B Testing Framework**: Users can instantiate structured trials (e.g., *Fasted vs. Fed*, *High Sleep vs. Low Sleep*).
- **The Delta Engine**: The app automatically aggregates all `ExerciseResult` data generated under Tag A versus Tag B. It then calculates the strict percentage delta in both reaction time and accuracy, revealing actionable insights into what biological interventions genuinely optimize cognitive output.

---

## 🧩 Psychometric Modules

ClarityPulse employs gold-standard cognitive stress tasks engineered for high-performance, low-latency collection:

- **N-Back Task (Working Memory)**: A grueling test of working memory updating and capacity. The UI utilizes strict asynchronous state timing and explicit view lifecycle controls to ensure inter-stimulus intervals (ISI) are clinically precise and visually flawless.
- **Stroop Task (Cognitive Flexibility)**: A rapid-fire assessment of selective attention, cognitive flexibility, and processing speed, challenging the brain's ability to override automated reading responses.
- **Cognitive Archetype Engine**: A dynamic algorithmic engine that parses longitudinal data to assign a functional archetype:
  - 🎯 **The Sniper**: High accuracy, slower reaction time.
  - ⚡️ **The Sprinter**: High speed, higher error rate.
  - ⏱ **The Metronome**: The perfect clinical baseline of speed and precision.

---

## 🎨 UI/UX Design System: Anti-Fatigue Glassmorphism

The interface of ClarityPulse is engineered to be a "clinical-yet-engaging" environment that prevents visual fatigue over long-term daily use.

- **Native System Dark Mode**: Completely dynamic rendering without hardcoded light/dark overrides.
- **The Glassmorphic Architecture**: All data cards and interactable modules utilize `.regularMaterial` and `.ultraThinMaterial` backgrounds.
- **Frosted Edges**: A subtle `0.5px` `.primary.opacity(0.08)` stroke overlay provides a premium "frosted glass edge" that pops brilliantly against the deep `.systemGroupedBackground`.
- **Tactile UI**: Deep integration of `UIImpactFeedbackGenerator(style: .medium)` across all critical user interactions ensures a heavy, responsive, high-performance feel.
- **Unified Clinical Teal**: All focal elements, charts, and primary buttons are anchored by a unified `.teal` accent color.

---

## 💻 Installation & Setup

ClarityPulse uses **XcodeGen** to completely decouple the Xcode project file from source control, preventing notorious `.pbxproj` merge conflicts.

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/realrezi/ClarityPulse.git
   cd ClarityPulse
   ```
2. **Generate the Xcode Project**:
   Ensure you have [XcodeGen](https://github.com/yonaskolb/XcodeGen) installed globally (`brew install xcodegen`).
   ```bash
   xcodegen generate
   ```
3. **Build and Run**:
   Open `ClarityPulse.xcodeproj` in Xcode 15+ and select your target iOS Simulator or physical device (iOS 17.0+ required).

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
