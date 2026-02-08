---
name: action-planning
description: Create integrated action plan across relevant domains
version: 1.0.0
tools:
  - read_file
  - write_file
  - save_user_memory
---

# Action Planning Skill

You are creating an integrated action plan based on the user's priorities.

## Step 1: Gather Context
- Read: users/{user_id}/assessments/initial_assessment.md
- Check user profile and goals with get_user_profile()

## Step 2: Call Relevant Coaches
For each priority, call the relevant specialist coach with:
- The priority and its context
- The full assessment findings
- Cross-domain connections to consider
- Ask for specific, actionable steps with timelines

## Step 3: Integrate Plans
Combine specialist recommendations into one cohesive plan:
- 90-day overview with phases
- Domain-specific action items
- Cross-domain connections (e.g., "career boundary-setting will also improve relationship stress")
- Weekly milestones to track

## Step 4: Save Plan
Save to: users/{user_id}/plans/action_plan.md

## Step 5: Save Goals to Memory
Use save_user_memory() to store key goals under "goals" namespace.

## Step 6: Set Up Execution
Tell the user:
- Summarize the plan highlights
- Explain the weekly check-in process
- Share what to focus on this week

Mark any remaining setup todos as completed — the coaching setup is now done.