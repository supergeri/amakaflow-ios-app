# Correct Entitlements Path

## Current Issue

"Code Signing Entitlements" shows:
- ❌ `App/AmakFlowWatch.entitlements` (incomplete path)

Should be:
- ✅ `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements` (full path)

## Fix: Update the Path

### Step 1: Update the Value

1. **In Build Settings**, find "Code Signing Entitlements"
2. **Double-click** the value field that shows `App/AmakFlowWatch.entitlements`
3. **Replace it with**: `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements`
4. **Press Enter**

### Step 2: Use File Browser (Easier Method)

1. **Click the folder icon** (📁) next to the "Code Signing Entitlements" field
2. **In the file browser**, navigate to:
   - `AmakaFlowWatch Watch App` folder
3. **Select**: `AmakFlowWatch.entitlements` file
4. **Click "Open"**

This will automatically set the correct path.

### Step 3: Verify

After updating, the field should show:
- ✅ `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements`

**NOT**:
- ❌ `App/AmakFlowWatch.entitlements` (incomplete)
- ❌ `AmakaFlowWatch Watch App` (just folder name)

### Step 4: Clean and Rebuild

1. **Clean Build Folder**: Product → Clean Build Folder (Shift + Cmd + K)
2. **Build**: Press Cmd + B
3. **Error should be resolved!**

## Why This Matters

The path must match the actual file location:
- **Actual file location**: `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements`
- **Build Settings path**: Must match exactly

If the path is wrong, Xcode can't find the file and the build fails.

## Summary

- ❌ **Current**: `App/AmakFlowWatch.entitlements` (missing folder name)
- ✅ **Correct**: `AmakaFlowWatch Watch App/AmakFlowWatch.entitlements` (full path)
- 📍 **Location**: Build Settings → Code Signing Entitlements


