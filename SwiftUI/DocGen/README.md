# About DocGen
An on-device, menu bar application for ***macOS*** that generates Apple DocC-compliant documentation for Swift functions.

Powered by `Apple MLX` and ***Qwen2.5-Coder-7B***, DocGen uses static AST analysis via `SwiftSyntax` and on-device AI Model to generate documentation locally and privately without sending code to cloud servers.

# Key Features
* **Menu Bar Utility**: Built with SwiftUI's `MenuBarExtra`, DocGen runs unobtrusively in the macOS menu bar and triggers documentation generation when opened.
* **100% On-Device & Private**: Driven by MLX Swift, all token generation happens locally on Apple Silicon unified memory—zero network dependencies, zero telemetry.
* **AST-Driven Metadata Extraction**: Uses `SwiftSyntax` to parse function declarations, parameter labels, types, return clauses, and throws specifiers, enforcing strict structural rules on the LLM prompt.
* **Quick Keyboard Shortcuts**: Copy generated DocC comments directly to the clipboard with Cmd+C or quit with Cmd+Q.

# How It Works
A[Copy Swift Function] --> B[Click DocGen Menu Bar Icon]\
B --> C[MenuObserver Detects Open]\
C --> D[SwiftSyntax AST Extraction]\
D --> E[Build Constrained Prompt]\
E --> F[MLX Qwen2.5-Coder Inference]\
F --> G[Copy DocC with Cmd+C]

1. **Clipboard Observation**: When opening the menu bar icon, `MenuObserver` detects the tracking event and retrieves the clipboard content.
2. **Syntax Validation**: `FunctionMetadataExtractor` inspects the snippet using `SwiftParser`. If valid, it extracts the function name, parameter list, return type, and throw capabilities.
3. **Constrained AI Prompting**: `AIManager` formats a system prompt containing strict structural rules derived from the extracted metadata (preventing hallucinations, missing tags, or phantom parameters).
4. **On-Device Inference**: The ***Qwen2.5-Coder*** model generates DocC lines (///) with zero temperature for deterministic output.

# Requirements
### Model Requirements and Placement
DocGen runs the [Qwen2.5-Coder-7B](https://huggingface.co/mlx-community/Qwen2.5-Coder-7B-4bit) language model in Apple MLX / Hugging Face format.

### Required Model Files
The following configuration, tokenizer, and weight files must be present:
1. added_tokens.json
2. config.json
3. merges.txt
4. model.safetensors
5. model.safetensors.index.json
6. special_tokens_map.json
7. tokenizer_config.json
8. tokenizer.json
9. vocab.json

### Placement in Xcode
DocGen loads model weights directly from the main application bundle (Bundle.main.resourceURL):\
Place the files inside DocGen/DocGen/Qwen2.5-Coder-7B.
