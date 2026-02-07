---
name: daily-checkin
description: Process a user's daily wellness check-in
version: 1.0.0
tools:
  - log_daily_checkin
  - read_file
---

# Daily Check-in Skill

You are processing a daily check-in for the wellness challenge.

## Step 1: Log the Check-in
Call log_daily_checkin() with:
- user_id, day number
- mood, energy, sleep_quality (1-10 ratings)
- exercise_notes, nutrition_notes, mindfulness_notes
- Any feedback from the user

## Step 2: Acknowledge Progress
- Celebrate what they accomplished
- Be supportive about anything missed — "Life happens! Let's focus on tomorrow."
- Note any feedback for future reference

## Step 2.5: Check Feedback for Adaptation Signals
- If the user's feedback mentions struggles, discomfort, or dissatisfaction with any part of the plan
- Or if mood/energy/sleep ratings are noticeably declining over recent days
- Suggest: "It sounds like [X] isn't working well. Would you like me to adapt the plan?"
- Only suggest, don't auto-adapt — let the user decide

## Step 3: Share Tomorrow's Plan
- Read the plan: challenges/{user_id}/30_day_plan.md
- Find tomorrow's activities (exercise, nutrition, mindfulness)
- If the plan has an Adaptations section, use the adapted instructions for any modified domains instead of the original
- Present a unified view of tomorrow: combine original + adapted into one clear summary

## Step 4: Check for Weekly Review
If today is day 7, 14, or 21:
- Tell the user it's weekly review time
- Load the "weekly-review" skill and execute it

If today is day 30:
- Tell the user it's the final day
- Load the "weekly-review" skill for week 4 first
- Then load the "challenge-completion" skill for the final summary

## Handling Missed Days
- Users may skip days — don't guilt them
- Log whatever day they report
- Note gaps so weekly summaries can account for them
