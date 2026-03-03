# Session 15: 🚢 Agent Servers

🎯 Learn to deploy complex agent applications to production endpoints that you can use elsewhere.

📚 **Learning Outcomes**
- Learn to package, build, and deploy agents with tool and data access directly to a production API endpoint
- Understand how to use the API in full-stack end-to-end applications

🧰 **New Tools**
Deployment: [LangSmith Deployment](https://docs.langchain.com/langsmith/deployments)

Requires $30-40/month
   
## 📜 Recommended Reading
- [LangSmith Deployment components](https://docs.langchain.com/langsmith/components)
- [Agent Server](https://docs.langchain.com/langsmith/agent-server), by LangSmith

# 🗺️ Overview

## LangSmith Deployments

What used to be called LangGraph Cloud evolved into LangGraph Platform, and today deployment lives under the broader LangSmith umbrella. Regardless of branding velocity, the purpose remains the same: production infrastructure for running LangGraph applications.

Here’s why that matters:
- Enterprise-Ready: You can deploy in multiple ways, including fully managed cloud (SaaS), Bring Your Own Cloud (BYOC), or fully self-hosted. This makes it suitable for teams with strict data privacy, security, or regulatory constraints.
- LangGraph Runtime Server: The deployment stack runs your LangGraph applications as API services. Unlike older tools like LangServe, this system is built specifically for stateful, long-running agent workflows, with built-in persistence and job orchestration.
- Built-In Infrastructure Components: Production deployments typically include persistent storage such as Postgres for state and history, along with queuing and backing services such as Redis to handle concurrency, retries, and reliability.
- Composable Infrastructure: LangGraph deployments integrate with your existing components, including embedding models, vector databases, external APIs, or GPU-backed model inference. You can scale horizontally via containers or Kubernetes as traffic increases.

Bottom line: The LangGraph deployment stack makes it significantly easier to move from a local agent prototype to a production-grade, stateful, and observable LLM application, whether you are deploying on your own hardware, inside your cloud account, or using fully managed hosting.
