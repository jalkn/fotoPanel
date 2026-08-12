import streamlit as st
import subprocess
import os
import glob

# Streamlit page layout configuration
st.set_page_config(page_title="Studio Mode Automation", layout="wide")

st.title("FOTOPANEL.ART — Studio Mode Automation")
st.markdown("### Headless Captures via Puppeteer & Node.js")

col1, col2 = st.columns(2)

with col1:
    if st.button("Run Headless Captures"):
        with st.spinner("Capturing studio frames in background..."):
            try:
                result = subprocess.run(["node", "capture.js"], capture_output=True, text=True, check=True)
                st.success("Studio mode process executed successfully.")
                st.text(result.stdout)
            except Exception as e:
                st.error(f"Execution error: {e}")

with col2:
    st.markdown("### Output Frames")
    output_dir = "output"
    if os.path.exists(output_dir):
        images = glob.glob(f"{output_dir}/*.png")
        for img_path in images:
            st.image(img_path, caption=os.path.basename(img_path))
    else:
        st.info("No captured images found in output/ directory.")
