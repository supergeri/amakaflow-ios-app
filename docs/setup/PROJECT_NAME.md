# Project Naming

## App Name

- **Display Name**: `AmakaFlow Companion` (shown to users on device home screen)
- **Product Name**: `AmakaFlowCompanion` (used for bundle identifier, no spaces)
- **Bundle Identifier**: `com.amakaflow.companion` (or similar)

## Watch App Name

- **Product Name**: `AmakaFlowWatch` (watchOS target)
- **Display Name**: `AmakaFlow Companion` (matches iOS app)

## Folder Structure

The folder structure uses `AmakaFlow/` and `AmakaFlowWatch/` for organization. These are internal folder names and don't affect the displayed app name.

## Why "Companion"?

This iOS app is a **companion app** that syncs workouts to Apple Watch and Calendar. A separate native **AmakaFlow** app will be created later with full workout workflow functionality (ingestion, validation, mapping, etc.).

## User-Facing Names

All user-facing text, Info.plist descriptions, and permission messages use:
- **"AmakaFlow Companion"** (with space and capital "C")

## Technical Names

Code identifiers, struct names, and folder names use:
- **"AmakaFlowCompanion"** or **"AmakaFlow"** (no spaces, for technical identifiers)

