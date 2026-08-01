# ClarityPulse

![iOS](https://img.shields.io/badge/iOS-17.0%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![Framework](https://img.shields.io/badge/Framework-SwiftUI%20%7C%20SwiftData-teal)
![License](https://img.shields.io/badge/License-MIT-green)

**Clear the fog. Return to your best self.**

ClarityPulse is a clinical-grade, native iOS application designed to quantify cognitive performance and track mental fatigue. Through precise psychometric assessments, it acts as a personal cognitive dashboard to measure speed, accuracy, and baseline fluctuations over time.

*Designed and Engineered by Ahmadreza Shirdel, MD*

---

## Clinical & Research Utility

ClarityPulse is built with an advanced **Micro-Trial Engine** that empowers users to conduct strict 7-day N-of-1 behavioral experiments (e.g., Fasted vs. Fed, High Sleep vs. Low Sleep).

The underlying `SwiftData` architecture is engineered cleanly, ensuring that all session metrics (Accuracy, Reaction Time, Config Type) are persistently linked to their tags. This structured schema allows future CSV data exports to be instantly and seamlessly ingested by R or Python pipelines for epidemiological analysis, meta-analysis, or training machine learning models.

## Features

- **Cognitive Archetype Profiler**: A dynamic algorithmic engine that calculates your baseline over time and assigns a functional archetype (e.g., *Speed-Biased Operator*, *The Perfect Baseline*) to help you understand your cognitive footprint.
- **N-Back & Stroop Tasks**: High-performance, low-latency implementations of gold-standard psychometric tasks designed with strict asynchronous state timing to guarantee precise response collection.
- **The Consistency Heatmap**: A GitHub-style 28-day visualization tracking your cognitive testing adherence, integrated seamlessly into the Progress Dashboard.
- **Micro-Trials Engine**: Tag your daily state (A vs. B) and play your sessions to uncover actionable insights into what truly maximizes your cognitive speed and accuracy.

## Architecture

ClarityPulse utilizes modern Apple ecosystem frameworks:
- **SwiftUI**: A meticulously crafted, glassmorphic UI built around native materials (`.regularMaterial`) and a unified `.teal` accent color for anti-fatigue dark mode support.
- **SwiftData**: Pure declarative data modeling using `@Model` to manage `ExerciseResult` and `MicroTrial` structures.
- **Navigation**: Adheres to modern item-based `.sheet(item:)` routing and reactive view lifecycle models.

## Installation & Build

ClarityPulse uses **XcodeGen** to strictly decouple the project file from source control, preventing `.pbxproj` merge conflicts.

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/ClarityPulse.git
   cd ClarityPulse
   ```
2. **Generate the Xcode Project**:
   Ensure you have [XcodeGen](https://github.com/yonaskolb/XcodeGen) installed (`brew install xcodegen`).
   ```bash
   xcodegen generate
   ```
3. **Build and Run**:
   Open `ClarityPulse.xcodeproj` in Xcode 15+ and select your target device or simulator (iOS 17.0+).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
