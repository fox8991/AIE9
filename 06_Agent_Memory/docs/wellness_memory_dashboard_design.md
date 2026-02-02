# Activity #2: Wellness Memory Dashboard - Design Summary

## Architecture Diagram

```
                         User Message
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  wellness_dashboard_agent                    │
│  ─────────────────────────────────────────────────────────  │
│  Retrieves from store:                                       │
│    1. Procedural  → ("agent", "instructions")               │
│    2. Profile     → (user_id, "profile")                    │
│    3. Metrics     → (user_id, "metrics")                    │
│    4. Recs        → (user_id, "recommendations")            │
│    5. Episodes    → (user_id, "episodes")                   │
│    6. Knowledge   → ("wellness", "knowledge")               │
│                                                              │
│  Builds system prompt → LLM → Response                       │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
                    Has feedback?
                     /         \
                   Yes          No
                   /             \
                  ▼               ▼
        ┌─────────────────┐    ┌─────┐
        │ reflection_node │    │ END │
        │ ─────────────── │    └─────┘
        │ Updates         │
        │ procedural      │
        │ memory          │
        └────────┬────────┘
                 ▼
              ┌─────┐
              │ END │
              └─────┘
```

## Memory Namespaces

| Namespace | Key | What's Stored | Updated By |
|-----------|-----|---------------|------------|
| `(user_id, "metrics")` | `{date}_{type}` | `{date, metric_type, value, notes}` | Offline (app/dashboard) |
| `(user_id, "profile")` | `"user_info"` | `{name, age, goals, constraints, ...}` | User settings |
| `(user_id, "episodes")` | `uuid` | `{situation, input, output, feedback, date}` | Batch job |
| `(user_id, "recommendations")` | `uuid` | `{date, recommendation, category}` | Agent (TODO) |
| `("agent", "instructions")` | `"wellness_assistant"` | `{instructions, version}` | reflection_node |
| `("wellness", "knowledge")` | `"chunk_{i}"` | `{text, source}` | Pre-loaded |

## How Reflection Works

1. User provides `feedback` in state (e.g., "be more concise")
2. `should_reflect()` routes to `reflection_node`
3. `reflection_node`:
   - Gets current instructions from `("agent", "instructions")`
   - Asks LLM to merge feedback into instructions
   - Saves updated instructions with `version + 1`
4. Future responses use updated instructions

## Key Functions

| Function | Purpose |
|----------|---------|
| `log_wellness_metric()` | Store daily metric (key: `date_type`) |
| `get_wellness_history()` | Retrieve last N days of metrics |
| `format_metrics()` | Convert metrics to string for LLM |
| `store_recommendation()` | Log agent's suggestion for cross-thread context |

## What Each Memory Type Enables

- **Metrics + Notes** → LLM analyzes trends, sees what user tried
- **Recommendations** → Cross-thread context ("breathing technique you suggested")
- **Episodes** → Proven strategies ("morning walk worked before")
- **Knowledge** → Evidence-based advice
- **Procedural** → Adapts response style based on feedback
- **Short-term (checkpointer)** → Conversation context within same thread

## Design Decisions

### Episodic Memory Updates
- Updated via **batch job** (not real-time)
- Batch job analyzes: recommendations + metrics trends + user feedback
- Creates high-confidence episodes linking what worked

### Metrics Logging
- Done **offline** via app/dashboard, not through chat
- Key format: `{date}_{metric_type}` (e.g., "2024-01-15_mood")
- Notes field captures context (e.g., "tried breathing technique")

### Recommendations Storage
- Enables **cross-thread attribution**
- When user says "the breathing technique helped" in a new thread, agent can find the original recommendation
- TODO: Auto-extract recommendations from agent responses
