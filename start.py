import os
from pathlib import Path
from sys import platform

def launch_exe(posix: bool):
    from dotenv import load_dotenv

    load_dotenv()


    main_path = Path.cwd() / "main.t"
    turing_path = os.getenv("TURING_PATH")
    turing_path = rf"{turing_path}"

    os.chdir(turing_path)

    if posix:
        main_path = str(main_path).replace("/", "\\")
        command = rf'wine turing.exe -run Z:"{main_path}"'
    else:
        command = rf'turing.exe -run "{main_path}"'

    os.system(command)


match platform:
    case "linux":
        launch_exe(posix=True)
    case "darwin":
        launch_exe(posix=True)
    case "win32":
        launch_exe(posix=False)
    case _:
        print("An unsupported platform was detected, please launch main.t manually")
