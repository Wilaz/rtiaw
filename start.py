import os
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()

turing_path = os.getenv('TURING_PATH')
turing_path = rf'{turing_path}'
main_path = Path.cwd() / "main.t"

os.chdir(turing_path)

command = rf'turing.exe -run "{main_path}"'

os.system(command)