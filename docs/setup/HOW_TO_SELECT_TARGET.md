# How to Select a Target in Xcode

## Selecting a Target

When you need to configure a target (like **AmakaFlowWatch**), follow these steps:

### Step 1: Click the Project (Blue Icon)

1. In the **Project Navigator** (left sidebar)
2. Click on the **blue project icon** at the very top (usually named "AmakaFlowCompanion")
   - This is the project file, not a folder
   - It has a blue icon with a document symbol

### Step 2: Select the Target

After clicking the project icon, the main editor area will show:

**Left Side:**
- **PROJECT** section (with your project name)
- **TARGETS** section (list of all targets)

**To select AmakaFlowWatch target:**

1. Look for the **TARGETS** section in the main editor area
2. You'll see a list like:
   - **AmakaFlowCompanion** (iOS app)
   - **AmakaFlowWatch** (watchOS app)
   - **AmakaFlowCompanionTests** (iOS tests)
   - **AmakaFlowWatchTests** (watchOS tests)
3. **Click on "AmakaFlowWatch"** in the TARGETS list
4. The target will be highlighted/selected

### Step 3: Configure the Target

Once **AmakaFlowWatch** is selected:
- The tabs at the top will show settings for that target:
  - General
  - Signing & Capabilities
  - Resource Tags
  - Info
  - Build Settings
  - Build Phases
  - Build Rules

### Visual Guide

```
Project Navigator (Left Sidebar)
├── 📁 AmakaFlowCompanion (blue icon) ← Click this first
│   ├── 📁 AmakaFlowCompanion
│   ├── 📁 AmakaFlowWatch Watch App
│   └── ...
│
Main Editor Area (After clicking project)
├── PROJECT
│   └── AmakaFlowCompanion
│
└── TARGETS ← Look here
    ├── AmakaFlowCompanion ← iOS target
    └── AmakaFlowWatch ← Click this for watchOS target
```

## Quick Steps Summary

1. **Click the blue project icon** at top of Project Navigator
2. **Find TARGETS section** in main editor
3. **Click "AmakaFlowWatch"** in the TARGETS list
4. **Configure** using the tabs (Signing & Capabilities, etc.)

## Common Mistake

❌ **Don't click** on the folder "AmakaFlowWatch Watch App" in Project Navigator
✅ **Do click** on the blue project icon, then select "AmakaFlowWatch" from TARGETS list

The folder is just for organizing files. The target is what you configure.

