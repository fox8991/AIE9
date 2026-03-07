"""An agent graph with a post-response dopeness check loop.

After the agent responds, a secondary node evaluates dopeness.
If dope, end; otherwise, continue the loop or terminate after a safe limit.
"""
from __future__ import annotations

from pydantic import BaseModel, Field

from langgraph.graph import StateGraph, START, END
from langgraph.prebuilt import ToolNode
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.messages import AIMessage, SystemMessage

from app.state import MessagesState
from app.models import get_chat_model
from app.tools import get_tool_belt


class DopenessResult(BaseModel):
    is_dope: bool = Field(description="Only True if the response is genuinely creative, funny, or memorable — not just slightly informal")

def _build_model_with_tools():
    """Return a chat model instance bound to the current tool belt."""
    model = get_chat_model()
    return model.bind_tools(get_tool_belt())


_SYSTEM_PROMPT = (
    "Make your answers rad, ensure high levels of dopeness. "
    "Do not be generic, or give generic responses. Be creative and engaging."
)


def call_model(state: MessagesState) -> dict:
    """Invoke the model with a dopeness-oriented system prompt."""
    model = _build_model_with_tools()
    messages = [SystemMessage(content=_SYSTEM_PROMPT)] + state["messages"]
    response = model.invoke(messages)
    return {"messages": [response]}


def route_to_action_or_dopeness(state: MessagesState):
    """Decide whether to execute tools or run the dopeness evaluator."""
    last_message = state["messages"][-1]
    if getattr(last_message, "tool_calls", None):
        return "action"
    return "dopeness"


_dopeness_prompt = ChatPromptTemplate.from_template(
    "You are assessing a submission based on the following criterion:\n\n"
    "dopeness: Is this response dope, lit, cool, or is it just a generic response?\n\n"
    "A dope response is creative, engaging, uses vivid language, and avoids "
    "boilerplate or cookie-cutter phrasing.\n\n"
    "Initial Query:\n{initial_query}\n\n"
    "Submission:\n{final_response}\n\n"
    "Does the submission meet the criterion?"
)


def dopeness_node(state: MessagesState) -> dict:
    """Evaluate dopeness of the latest response relative to the initial query."""
    if len(state["messages"]) > 10:
        return {"messages": [AIMessage(content="DOPENESS:END")]}

    initial_query = state["messages"][0]
    final_response = state["messages"][-1]

    structured_model = get_chat_model(model_name="gpt-4.1-mini").with_structured_output(DopenessResult)
    result = (_dopeness_prompt | structured_model).invoke(
        {
            "initial_query": initial_query.content,
            "final_response": final_response.content,
        }
    )

    decision = "Y" if result.is_dope else "N"
    return {"messages": [AIMessage(content=f"DOPENESS:{decision}")]}


def dopeness_decision(state: MessagesState):
    """Terminate on 'DOPENESS:Y' or loop otherwise; guard against infinite loops."""
    if any(getattr(m, "content", "") == "DOPENESS:END" for m in state["messages"][-1:]):
        return END

    last = state["messages"][-1]
    text = getattr(last, "content", "")
    if "DOPENESS:Y" in text:
        return "end"
    return "continue"


def build_graph():
    """Build an agent graph with an auxiliary dopeness evaluation loop."""
    graph = StateGraph(MessagesState)
    tool_node = ToolNode(get_tool_belt())
    graph.add_node("agent", call_model)
    graph.add_node("action", tool_node)
    graph.add_node("dopeness", dopeness_node)
    graph.add_edge(START, "agent")
    graph.add_conditional_edges(
        "agent",
        route_to_action_or_dopeness,
        {"action": "action", "dopeness": "dopeness"},
    )
    graph.add_conditional_edges(
        "dopeness",
        dopeness_decision,
        {"continue": "agent", "end": END, END: END},
    )
    graph.add_edge("action", "agent")
    return graph


graph = build_graph().compile()
