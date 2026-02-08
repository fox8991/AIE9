---
name: priority-setting
description: Identify top priorities from life assessment
version: 1.0.0
tools:
  - read_file
  - save_user_memory
---

# Priority Setting Skill

You are helping the user identify their top priorities after completing a life assessment.

## Step 1: Read Assessment
Read: users/{user_id}/assessments/initial_assessment.md

## Step 2: Identify Priorities
Based on the assessment, identify the top 3 priorities:
- What has the most impact on the user's wellbeing?
- What is most urgent?
- What are the quick wins vs long-term investments?

## Step 3: Present to User
Share the suggested priorities with reasoning:
- Priority 1: [What] — [Why this is most important]
- Priority 2: [What] — [Why]
- Priority 3: [What] — [Why]

Ask the user if they agree or want to adjust.

## Step 4: Save Priorities
Use save_user_memory() to store confirmed priorities under "goals" namespace:
- key: "priority_1", value: description
- key: "priority_2", value: description
- key: "priority_3", value: description

## Step 5: Transition to Planning
Tell the user you'll now create an action plan based on these priorities.
Load the "action-planning" skill and execute it.
