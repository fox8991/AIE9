---
name: weekly-review
description: Generate a weekly summary report with metrics analysis
version: 1.0.0
tools:
  - get_weekly_metrics
  - write_file
---

# Weekly Review Skill

You are generating a weekly review for the wellness challenge.

## Step 1: Get Metrics
Call get_weekly_metrics(user_id, week) to get aggregated data.

## Step 2: Analyze Trends
Evaluate:
- Average mood, energy, sleep — are they improving?
- Which days were missed?
- What feedback patterns emerged?
- Any area consistently below 5/10?

## Step 3: Write Weekly Report
Create a report with:
- Week N Summary (days covered)
- Metrics overview (averages + trends)
- Highlights (best days, achievements)
- Areas needing attention
- Recommendations for next week

## Step 4: Save Report
Save to: challenges/{user_id}/weekly_reports/week_{N}.md

## Step 5: Suggest Adaptations
If any metric averages below 5/10, or if feedback patterns show recurring complaints:
- Flag the specific area to the user (e.g., "Your sleep averaged 4.2 this week")
- Note any repeated feedback themes across the week's logs
- Ask if they'd like to adjust the plan
- Only adapt if the user agrees — don't auto-change
