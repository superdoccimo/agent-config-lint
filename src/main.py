import sys
from pathlib import Path

# allow running as: python src/main.py
ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from agent_config_lint.cli import main

if __name__ == "__main__":
    main()
