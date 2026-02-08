---
name: life-assessment
description: Conduct initial multi-domain life assessment
version: 1.0.0
tools:
  - write_file
  - write_todos
  - get_user_profile
  - save_user_memory
---

# Life Assessment Skill

You are conducting an initial life assessment for a new coaching client.

## Step 1: Check Existing Profile
Call get_user_profile(user_id) to see if there's any prior information.

## Step 2: Identify Relevant Domains
Based on the user's message, determine which domains are relevant:
- Career (job, skills, professional growth)
- Relationships (communication, boundaries, social)
- Finance (budgeting, saving, financial goals)
- Wellness (health, stress, sleep, habits)

Not all domains will be relevant — only assess what the user brings up or what's clearly connected.

## Step 3: Call Relevant Coaches
For each relevant domain, call the specialist coach with:
- The user's situation description
- Any cross-domain context (e.g., "career stress is affecting relationships")
- Ask them to assess strengths, challenges, and opportunities

If domains interact, call sequentially and pass prior coach context.
If domains are independent, call in parallel.

## Step 4: Save Assessment
Integrate all coach responses into one assessment document:
- Summary of situation
- Domain-by-domain findings
- Cross-domain connections identified
- Initial observations

Save to: users/{user_id}/assessments/initial_assessment.md

## Step 5: Save Key Info to Memory
Use save_user_memory() to store:
- Basic profile info under "profile" namespace
- Any goals mentioned under "goals" namespace

## Step 6: Transition to Priority Setting
Tell the user you'll now help them identify their top priorities.
Load the "priority-setting" skill and execute it.
