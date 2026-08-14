import streamlit as st
import streamlit.components.v1 as components
import os

st.set_page_config(page_title="FOTOPANEL.ART", layout="wide")

html_file_path = os.path.join(os.path.dirname(__file__), "index.html")

if os.path.exists(html_file_path):
    with open(html_file_path, "r", encoding="utf-8") as f:
        html_content = f.read()
    
    # Render component with HTML content
    components.html(html_content, height=850, scrolling=True)
else:
    st.error("index.html not found. Please execute ./set.sh first.")