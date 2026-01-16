<p align = "center" draggable=”false” ><img src="https://github.com/AI-Maker-Space/LLM-Dev-101/assets/37101144/d1343317-fa2f-41e1-8af1-1dbb18399719" 
     width="200px"
     height="auto"/>
</p>

## <h1 align="center" id="heading">Session 2: Dense Vector Retrieval</h1>

### [Quicklinks](https://github.com/AI-Maker-Space/AIE9/tree/main/00_AIE_Quicklinks)

| 📰 Session Sheet | ⏺️ Recording     | 🖼️ Slides        | 👨‍💻 Repo         | 📝 Homework      | 📁 Feedback       |
|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|:-----------------|
|[Dense Vector Retrieval](../00_Docs/Session_Sheets/02_Dense_Vector_Retrieval.md) |[Recording!](https://us02web.zoom.us/rec/share/91RvgSsquU3LHdQIelq_XfsX_um9NrqaN5YBBBHtnUbkDLo5Ngy7otxlDGCTLBrV.zwbgMtyEdRE5dASI) (%N6ZHDEz)| [Session 2 Slides](https://www.canva.com/design/DAG-EJWkrYk/Oj3SPEB09HDScDpnEiWHMA/edit?utm_content=DAG-EJWkrYk&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton) | You are here! | [Session 2 Assignment: Pythonic RAG](https://forms.gle/WB87UU7S1vp93yUZ9) | [Feedback 1/15](https://forms.gle/9qZGU19jGmg4RZdd8) |



### Outline:

🤜 BREAKOUT ROOM #1:
- Task 1: Imports and Utilities
- Task 2: Documents
- Task 3: Embeddings and Vectors
- Task 4: Prompts
- Task 5: Retrieval Augmented Generation
     - 🚧 ACTIVITY #1: Augment RAG

### Steps to Run:

1. Install UV - which you can do through [this resource](https://docs.astral.sh/uv/#getting-started)
2. Run the command `uv sync`
3. Open your Jupyter notebook and select `.venv` for your kernel. 

# Build 🏗️

Run the notebook!

# Ship 🚢

- Add one of the following "extras" (or whatever augmentations suit your use-case) to the RAG pipeline:
     - Allow it to work with PDF files
     - Implement a new distance metric
     - Add metadata support to the vector database
     - Use a different embedding model
     - Add the capability to ingest a YouTube link
- Make a simple diagram of your RAG process
- Run the notebook
- When you're finished with augmentations to your RAG application - vibe check it against the old one - see if you can "feel the improvement!
- Record a Loom walking through the notebook, the questions in the notebook, and your addition!

# Share 🚀
- Show your App in a loom video and explain the diagram
- Make a social media post about your final application and tag @AIMakerspace
- Share 3 lessons learned
- Share 3 lessons not learned

Here's a template to get your post started!

```
🚀 Exciting News! 🎉

I just built and augmented my very first Pythonic RAG Application using the OpenAI API! 🤖💼 

🔍 Three Key Takeaways:
1️⃣ Building RAG from scratch really helps you understand how retrieval and generation work together. 🧠✨
2️⃣ Augmenting a RAG pipeline (PDF support, new distance metrics, metadata, etc.) opens up so many possibilities! 🌱📈
3️⃣ Dive deep, keep iterating, and never stop learning. Each project brings a new set of challenges and equally rewarding lessons. 🔄📚

A huge shoutout to the @AI Makerspace for their invaluable resources and guidance. 🙌

Looking forward to more AI-driven adventures! 🌟 Feel free to connect if you'd like to chat more about it! 🤝

```

# Submitting Your Homework
## Main Assignment
Follow these steps to prepare and submit your homework:
1. Pull the latest updates from upstream into the main branch of your AIE9 repo:
    - _(You should have completed this process already):_ For your initial repo setup see [Initial_Setup](https://github.com/AI-Maker-Space/AIE9/tree/main/00_Docs/Prerequisites/Initial_Setup)
    - To get the latest updates from AI Makerspace into your own AIE9 repo, run the following commands:
    ```
    git checkout main
    git pull upstream main
    git push origin main
    ```
2. **IMPORTANT:** Start Cursor from the `02_Dense_Vector_Retrieval` folder (you can also use the _File -> Open Folder_ menu option of an existing Cursor window)
3. Answer Questions 1 - 4 using the `✅ Answer:` markdown cell below them.
4. Complete Activity #1 _(Enhance your RAG application in some way!)_ at the end of the notebook:
   + "your RAG application" refers to the code cells of this notebook, as well as the code in the `aimakerspace` library.
   + At the end of the file is a Python code cell where you will enter the code to enhance the application
   + If you so desire, you can also implement some of the code in new `.py` files and `import` the functionality into that final code cell.
5. Add, commit and push your modified `Pythonic_RAG_Assignment.ipynb` to your GitHub repository.

When submitting your homework, provide:
- Your Loom video link
- The GitHub URL to your completed notebook
