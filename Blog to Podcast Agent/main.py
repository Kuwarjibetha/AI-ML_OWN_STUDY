import os
from uuid import uuid4

from agno.agent import Agent
from agno.run.agent import RunOutput
from agno.models.google import Gemini
from agno.tools.firecrawl import FirecrawlTools

from elevenlabs import ElevenLabs
import streamlit as st



st.set_page_config(
    page_title=" Blog to Podcast (Gemini 2.5)",
    page_icon="🎙️"
)
st.title(" Blog to Podcast Agent (Gemini 2.5)")


# -------------------------------------------------
# Sidebar - API Keys
# -------------------------------------------------
st.sidebar.header(" API Keys")

gemini_key = st.sidebar.text_input("Gemini API Key", type="password")
firecrawl_key = st.sidebar.text_input("Firecrawl API Key", type="password")
elevenlabs_key = st.sidebar.text_input("ElevenLabs API Key", type="password")



# Blog URL Input

url = st.text_input("Enter Blog URL:")



# Generate Podcast Button

if st.button(
    "🎙️ Generate Podcast",
    disabled=not all([gemini_key, firecrawl_key, elevenlabs_key])
):
    if not url.strip():
        st.warning("Please enter a valid blog URL")
    else:
        with st.spinner("Scraping blog and generating podcast..."):
            try:

                # Environment Variables
              
                os.environ["GEMINI_API_KEY"] = gemini_key
                os.environ["FIRECRAWL_API_KEY"] = firecrawl_key
              
                agent = Agent(
                    name="Blog Summarizer Agent",
                    model=Gemini(
                        id="gemini-2.5-pro",
                        api_key=gemini_key
                    ),
                    tools=[FirecrawlTools()],
                    instructions=[
                        "Scrape the given blog URL.",
                        "Create a concise, engaging podcast-style summary.",
                        "Use conversational language.",
                        "Maximum length: 2000 characters."
                    ],
                )


                response: RunOutput = agent.run(
                    f"Scrape and summarize this blog for a podcast: {url}"
                )

                summary = (
                    response.content
                    if hasattr(response, "content")
                    else str(response)
                )

                if not summary:
                    st.error(" Failed to generate summary")

                client = ElevenLabs(api_key=elevenlabs_key)

                audio_stream = client.text_to_speech.convert(
                    text=summary,
                    voice_id="JBFqnCBsd6RMkjVDRZzb",
                    model_id="eleven_multilingual_v2"
                )

                audio_chunks = []
                for chunk in audio_stream:
                    if chunk:
                        audio_chunks.append(chunk)

                audio_bytes = b"".join(audio_chunks)

                st.success(" Podcast generated successfully!")

                st.audio(audio_bytes, format="audio/mp3")

                filename = f"podcast_{uuid4().hex}.mp3"
                st.download_button(
                    label="⬇️ Download Podcast",
                    data=audio_bytes,
                    file_name=filename,
                    mime="audio/mp3"
                )

                with st.expander("📄 Podcast Summary"):
                    st.write(summary)

            except Exception as e:
                st.error(f"❌ Error: {e}")
