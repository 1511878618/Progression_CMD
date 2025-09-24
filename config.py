from pathlib import Path

project_dir = Path("V1")
project_dir.mkdir(exist_ok=True, parents=True)

outputDir = project_dir / "output"
dataDir = project_dir / "data"

outputDir.mkdir(exist_ok=True)
dataDir.mkdir(exist_ok=True)


PaperDir = project_dir / "Paper"
TableDir = project_dir / "Table"
FigureDir = project_dir / "Figure"
# CodeDir = project_dir / "Code"
PaperDir.mkdir(exist_ok=True)
TableDir.mkdir(exist_ok=True)
FigureDir.mkdir(exist_ok=True)
# CodeDir.mkdir(exist_ok=True)
