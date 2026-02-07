---
name: challenge-completion
description: Generate final summary when user completes the 30-day challenge
version: 1.0.0
tools:
  - get_weekly_metrics
  - write_file
---

# Challenge Completion Skill

The user has completed Day 30! Generate a comprehensive final summary.

## Step 1: Log Final Check-in
Make sure day 30 is logged before proceeding.

## Step 2: Gather All Metrics
Call get_weekly_metrics() for weeks 1-4 to get the full picture.

## Step 3: Write Final Summary
Create a comprehensive report with:
- Overall completion rate (days logged / 30)
- Metric trends across all 4 weeks (mood, energy, sleep)
- Week-over-week comparisons
- Biggest achievements and improvements
- Areas of consistent strength
- Challenges faced and how they were handled

## Step 4: Recommendations
Provide guidance for maintaining habits:
- Which habits to keep
- Suggested next challenge or progression
- Long-term wellness tips

## Step 5: Save & Celebrate
- Save to: challenges/{user_id}/final_summary.md
- Celebrate their achievement enthusiastically!
