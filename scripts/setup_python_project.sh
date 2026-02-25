#!/usr/bin/env bash

# Script to setup a Python project with uv, ty, and ruff
# Usage: ./setup_python_project.sh [project_name] [python_version]

set -e

PROJECT_NAME="${1:-my_project}"
PYTHON_VERSION="${2:-3.14}"

echo "🚀 Setting up Python project: $PROJECT_NAME"
echo "📦 Python version: $PYTHON_VERSION"

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "❌ uv is not installed. Installing..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Initialize project if pyproject.toml doesn't exist
if [ ! -f "pyproject.toml" ]; then
    echo "📝 Initializing new project..."
    uv init --name "$PROJECT_NAME" --python "$PYTHON_VERSION"
else
    echo "✓ Found existing pyproject.toml"
fi

# Install ty and ruff as dev dependencies
echo "📚 Installing ty and ruff..."
uv add --dev ty ruff

# Add ty configuration to pyproject.toml
echo "⚙️  Configuring ty (type checker)..."
if ! grep -q "\[tool.ty\]" pyproject.toml; then
    cat >> pyproject.toml << 'EOF'

[tool.ty.analysis]
# Honor type: ignore comments
respect-type-ignore-comments = true

[tool.ty.rules]
# Configure rule severity (options: "ignore", "warn", "error")
# Set stricter defaults for better type safety
all = "warn"
possibly-unresolved-reference = "error"
unresolved-import = "error"

[tool.ty.src]
# Respect .gitignore files
respect-ignore-files = true

[tool.ty.terminal]
# Output format: "full" or "concise"
output-format = "full"
error-on-warning = false
EOF
    echo "✓ Added ty configuration"
else
    echo "✓ ty configuration already exists"
fi

# Add ruff configuration to pyproject.toml
echo "⚙️  Configuring ruff (linter)..."
if ! grep -q "\[tool.ruff\]" pyproject.toml; then
    cat >> pyproject.toml << 'EOF'

[tool.ruff]
# Ruff linter configuration
# Using 88 (Black's default) for consistency with the Python ecosystem
line-length = 88

[tool.ruff.lint]
# Enable specific rule sets
select = [
    "E",     # pycodestyle errors
    "W",     # pycodestyle warnings
    "F",     # pyflakes
    "I",     # isort
    "N",     # pep8-naming
    "UP",    # pyupgrade
    "B",     # flake8-bugbear
    "C4",    # flake8-comprehensions
    "SIM",   # flake8-simplify
    "RUF",   # ruff-specific rules
]
ignore = []

[tool.ruff.lint.per-file-ignores]
"__init__.py" = ["F401"]  # Allow unused imports in __init__.py

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
EOF
    echo "✓ Added ruff configuration"
else
    echo "✓ ruff configuration already exists"
fi

# Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    echo "📄 Creating .gitignore..."
    cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
.venv/
venv/
ENV/
env/

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~

# Type checking
.mypy_cache/
.dmypy.json
dmypy.json
.pytype/

# Testing
.pytest_cache/
.coverage
htmlcov/

# Ruff
.ruff_cache/
EOF
    echo "✓ Created .gitignore"
else
    echo "✓ .gitignore already exists"
fi

# Create a sample module with type hints
if [ ! -d "src" ] && [ ! -f "main.py" ]; then
    echo "📝 Creating sample main.py..."
    cat > main.py << 'EOF'
"""Sample Python module with type hints."""


def greet(name: str) -> str:
    """
    Greet a person by name.

    Args:
        name: The name of the person to greet

    Returns:
        A greeting message
    """
    return f"Hello, {name}!"


def main() -> None:
    """Main entry point."""
    message = greet("World")
    print(message)


if __name__ == "__main__":
    main()
EOF
    echo "✓ Created main.py"
fi

echo ""
echo "✅ Project setup complete!"
echo ""
echo "📋 Next steps:"
echo "  1. Run 'uv sync' to sync dependencies"
echo "  2. Run 'uv run ty check' to type check your code"
echo "  3. Run 'uv run ruff check .' to lint your code"
echo "  4. Run 'uv run ruff format .' to format your code"
echo "  5. Run 'uv run python main.py' to run your code"
echo ""
echo "💡 Tips:"
echo "  - Use 'uv run ty check --watch' for live type checking feedback"
echo "  - Use 'uv run ruff check --fix .' to auto-fix linting issues"
