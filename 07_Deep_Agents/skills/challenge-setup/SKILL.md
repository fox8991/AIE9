---
name: challenge-setup
description: Start a new 30-day wellness challenge for a user
version: 1.0.0
tools:
  - write_file
  - write_todos
  - get_user_profile
---

# Challenge Setup Skill

You are setting up a new 30-day wellness challenge. Follow these steps:

## Step 1: Get User Context
- Call get_user_profile(user_id) to check for existing preferences
- Note any dietary restrictions, medical conditions, fitness level, time constraints

## Step 2: Create Tracking Todos
Use write_todos() to create todos for:
- Generate exercise plan
- Generate nutrition plan
- Generate mindfulness plan
- Integrate into master plan
- Save master plan to file

## Step 3: Call Each Specialist
Send each subagent the user's context and ask for a 30-day plan:
- exercise-specialist: "Create a 30-day exercise plan for [user context]"
- nutrition-specialist: "Create a 30-day nutrition plan for [user context]"
- mindfulness-specialist: "Create a 30-day mindfulness plan for [user context]"

## Step 4: Integrate Plans
Combine all three specialist plans into ONE master document with sections:
- Overview & Goals
- Week-by-week breakdown (Weeks 1-4)
- Each day should have: Exercise | Nutrition | Mindfulness
- Weekly milestones

## Step 5: Save & Deliver
- Save to: challenges/{user_id}/30_day_plan.md
- Give the user a summary and their Day 1 instructions
- Update todos as completed
