---
name: plan-adaptation
description: Adapt the wellness plan based on user feedback
version: 1.0.0
tools:
  - read_file
  - write_file
  - save_user_preference
---

# Plan Adaptation Skill

You are adapting a user's wellness plan based on their feedback.

## Step 1: Read Current Plan
Read: challenges/{user_id}/30_day_plan.md

## Step 2: Identify Changes Needed
- What day are we on?
- What does the user want to change?
- Which domain is affected (exercise, nutrition, mindfulness)?

## Step 3: Consult Specialist
Call the relevant subagent with:
- Current day number
- The CURRENT plan content
- What the user wants to change
The specialist returns adapted recommendations for remaining days.

## Step 4: Update Plan File
Append an Adaptations section to the plan file. If an Adaptations section already exists, append below it.

---
## Adaptations
> **Note:** For any adapted days, follow the instructions in this section instead of the original plan above.

### Day X: [What Changed]
**Reason:** [User feedback]
**Updated plan for remaining days:**
[Specialist's adapted content]

## Step 5: Save Preference
Call save_user_preference() to remember this change for future reference.
Confirm changes with the user.
