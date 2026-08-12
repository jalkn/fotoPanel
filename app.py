import streamlit as st
import streamlit.components.v1 as components
import os

st.set_page_config(page_title="FOTOPANEL.ART", layout="wide")

# Cargar index.html
html_file_path = os.path.join(os.path.dirname(__file__), "index.html")

if os.path.exists(html_file_path):
    with open(html_file_path, "r", encoding="utf-8") as f:
        html_content = f.read()
    components.html(html_content, height=800, scrolling=True)
else:
    st.error("No se encontró el archivo index.html. Por favor ejecuta ./set.sh primero.")