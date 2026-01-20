import os
from typing import List, Dict, Any
from pypdf import PdfReader
from youtube_transcript_api import YouTubeTranscriptApi
import trafilatura


class Document:
    """A document with text content and metadata."""
    def __init__(self, text: str, metadata: Dict[str, Any] = None):
        self.text = text
        self.metadata = metadata if metadata is not None else {}

class BlogPostLoader:
    def __init__(self, blog_url: str):
        self.blog_url = blog_url
        self.documents = []

    def load_blog_post(self):
        html = trafilatura.fetch_url(self.blog_url)
        if html is None:
            raise ValueError(f"Failed to fetch blog post from {self.blog_url}")

        text = trafilatura.extract(html)
        if text is None:
            raise ValueError(f"Failed to extract text from {self.blog_url}")

        self.documents.append(text)

    def load_documents(self):
        self.load_blog_post()
        return self.documents

class YoutubeVideoLoader:
    def __init__(self, video_url: str):
        self.video_url = video_url
        self.documents = []

    def _extract_video_id(self) -> str:
        if "v=" in self.video_url:
            return self.video_url.split("v=")[1].split("&")[0]
        elif "youtu.be/" in self.video_url:
            return self.video_url.split("youtu.be/")[1].split("?")[0]
        else:
            return self.video_url

    def load_transcript(self):
        video_id = self._extract_video_id()

        ytt_api = YouTubeTranscriptApi()
        fetched_transcript = ytt_api.fetch(video_id)

        full_transcript = " ".join([segment.text for segment in fetched_transcript.snippets])

        self.documents.append(full_transcript)

    def load_documents(self):
        self.load_transcript()
        return self.documents

class PDFFileLoader:
    def __init__(self, path: str):
        self.documents = []
        self.path = path

    def load_file(self):
        reader = PdfReader(self.path)
        text = ""
        for page in reader.pages:
            text += page.extract_text() + "\n"
        self.documents.append(text)

    def load_directory(self):
        for root, _, files in os.walk(self.path):
            for file in files:
                if file.endswith(".pdf"):
                    reader = PdfReader(os.path.join(root, file))
                    text = ""
                    for page in reader.pages:
                        text += page.extract_text() + "\n"
                    self.documents.append(text)

    def load(self):
        if os.path.isdir(self.path):
            self.load_directory()
        elif os.path.isfile(self.path) and self.path.endswith(".pdf"):
            self.load_file()
        else:
            raise ValueError(
                "Provided path is neither a valid directory nor a .pdf file."
            )

    def load_documents(self):
        self.load()
        return self.documents

class TextFileLoader:
    def __init__(self, path: str, encoding: str = "utf-8"):
        self.documents = []
        self.path = path
        self.encoding = encoding

    def load(self):
        if os.path.isdir(self.path):
            self.load_directory()
        elif os.path.isfile(self.path) and self.path.endswith(".txt"):
            self.load_file()
        else:
            raise ValueError(
                "Provided path is neither a valid directory nor a .txt file."
            )

    def load_file(self):
        with open(self.path, "r", encoding=self.encoding) as f:
            self.documents.append(f.read())

    def load_directory(self):
        for root, _, files in os.walk(self.path):
            for file in files:
                if file.endswith(".txt"):
                    with open(
                        os.path.join(root, file), "r", encoding=self.encoding
                    ) as f:
                        self.documents.append(f.read())

    def load_documents(self):
        self.load()
        return self.documents


class CharacterTextSplitter:
    def __init__(
        self,
        chunk_size: int = 1000,
        chunk_overlap: int = 200,
    ):
        assert (
            chunk_size > chunk_overlap
        ), "Chunk size must be greater than chunk overlap"

        self.chunk_size = chunk_size
        self.chunk_overlap = chunk_overlap

    def split(self, text: str) -> List[str]:
        chunks = []
        for i in range(0, len(text), self.chunk_size - self.chunk_overlap):
            chunks.append(text[i : i + self.chunk_size])
        return chunks

    def split_texts(self, texts: List[str]) -> List[str]:
        chunks = []
        for text in texts:
            chunks.extend(self.split(text))
        return chunks

    def split_documents(self, documents: List[Document]) -> List[Document]:
        """Split documents while preserving metadata."""
        """Metadata is shared by all chunks of the same document in this implementation."""
        chunks = []
        for doc in documents:
            text_chunks = self.split(doc.text)
            for i, chunk in enumerate(text_chunks):
                chunk_metadata = doc.metadata.copy()
                chunk_metadata["chunk_index"] = i
                chunks.append(Document(text=chunk, metadata=chunk_metadata))
        return chunks


if __name__ == "__main__":
    loader = TextFileLoader("data/KingLear.txt")
    loader.load()
    splitter = CharacterTextSplitter()
    chunks = splitter.split_texts(loader.documents)
    print(len(chunks))
    print(chunks[0])
    print("--------")
    print(chunks[1])
    print("--------")
    print(chunks[-2])
    print("--------")
    print(chunks[-1])
