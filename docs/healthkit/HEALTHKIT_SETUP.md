# HealthKit Capability Setup Guide

## Modern Xcode (15+) - No Read/Write Checkboxes

In **Xcode 15+**, HealthKit doesn't have separate "Read" and "Write" checkboxes. Instead, access is controlled through **Usage Descriptions**. If you add a Usage Description, you implicitly get that type of access.

## What You See

In the HealthKit capability section, you'll see:

1. **Health Share** section (Read Access)
   - Usage Description field
   - When you add a description here, you get **READ** access

2. **Health Update** section (Write Access)
   - Usage Description field
   - When you add a description here, you get **WRITE** access

3. **Health Records** section (Clinical Records - Optional)
   - Usage Description field
   - For clinical health records access (usually not needed)

## What to Fill In

### Health Share (Read Access)

**Usage Description:**
```
AmakaFlow Companion needs access to read your workout data
```

### Health Update (Write Access)

**Usage Description:**
```
AmakaFlow Companion needs access to save your completed workouts
```

### Health Records (Optional - Can Leave Empty)

Only fill this if you need clinical health records. For workout syncing, you typically don't need this.

## How Access Works

- ✅ **Health Share description added** = You get READ access
- ✅ **Health Update description added** = You get WRITE access
- ✅ **Both descriptions added** = You get READ + WRITE access

## Steps

1. In **HealthKit** capability section, find **"Health Share"** subsection
2. Click the **Usage Description** text field
3. Type: `AmakaFlow Companion needs access to read your workout data`
4. Find **"Health Update"** subsection
5. Click the **Usage Description** text field
6. Type: `AmakaFlow Companion needs access to save your completed workouts`
7. Leave **"Health Records"** empty (unless you need clinical records)
8. Leave checkboxes unchecked (Clinical Health Records, Background Delivery) unless you need those specific features

## Verify It's Working

After adding the descriptions:
1. The HealthKit capability should show as configured
2. When you build and run the app, iOS will request these permissions
3. Users will see your usage descriptions when prompted

This is the modern way Xcode handles HealthKit permissions - through usage descriptions rather than checkboxes.

