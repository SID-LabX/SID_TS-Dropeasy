# TS-Dropeasy User Manual

Welcome to **TS-Dropeasy** — a minimal, drag-and-drop `.ts` to `.mp4` video converter built for simplicity and speed.

---

## 🛠️ Features

- 🎯 Convert `.ts` files to `.mp4` in one click
- 🖱️ Simple drag-and-drop interface
- 🚀 Fast and lightweight
- 📦 Portable `.exe` (no install required)

---

## ⚙️ How to Use

### 🪟 Windows Users

1. **Download the latest `.exe`** from the [Releases](https://github.com/BirunSID/TS-Dropeasy/releases) page.
2. **Place your `.ts` file(s)** on your desktop (or any easy location).
3. **Drag** your `.ts` file and **drop** it onto the `TStoMP4Converter.exe`.
4. A new `.mp4` version will be generated automatically in the same folder.

---

## 📁 Folder Structure

```bash
TS-Dropeasy/
├── assets/                  # Icons, banners, UI files
├── exe type/               # Executable files (not tracked in Git)
├── src/                    # Core Python or GUI code (if applicable)
├── LICENSE
├── README.md
├── MANUAL.md

🧪 Supported Formats
Input: .ts (Transport Stream)
Output: .mp4 (MPEG-4 Part 14)

🧼 Cleaning Up
Converted files will retain the original name, with a .mp4 extension.
Make sure there’s no special characters in the .ts filename.

🛡️ Safety & Notes
🔐 This tool does not upload, track, or log anything.
✅ Works offline.
❌ Do not run as admin unless necessary.
🧯 If it doesn’t convert, make sure the file isn't locked by another media player.

📥 Troubleshooting
Issue	Solution
.mp4 not generated	Ensure the .ts file isn't corrupt. Try running the .exe as admin once.
Error: Missing DLL	You might need Visual C++ Redistributables
Nothing happens	Make sure you're dragging a valid .ts file. Avoid shortcuts/symlinks.

🧠 Behind the Scenes
The converter uses ffmpeg wrapped in a lightweight GUI shell. It processes the file using direct stream copy to avoid re-encoding and preserve quality

🤝 Credits
Developed by Sidratul Al Birun
Built using Python + PyInstaller
Powered by FFmpeg

📄 License
This project is licensed under the MIT License.
See LICENSE for full terms.

🌐 Links
🔗 GitHub Repository
📦 Releases
🧠 Manual