import importlib.metadata
import json
import pathlib
import sys
import tomllib

root = pathlib.Path(sys.argv[1]).resolve()
lock = tomllib.loads((root / "uv.lock").read_text())
locked = {package["name"]: package["version"] for package in lock["package"]}
runtime = sys.version_info
if runtime < (3, 13):
    raise SystemExit(f"FAIL: existing project Python is {runtime.major}.{runtime.minor}; >=3.13 required")

versions = {}
for name in ("fastapi", "uvicorn"):
    try:
        installed = importlib.metadata.version(name)
    except importlib.metadata.PackageNotFoundError as error:
        raise SystemExit(f"FAIL: {name} is missing from the existing project environment") from error
    if installed != locked.get(name):
        raise SystemExit(f"FAIL: {name} {installed} does not match uv.lock ({locked.get(name)})")
    versions[name] = installed

print(json.dumps({"python": sys.version.split()[0], "packages": versions, "lock": "matched"}, sort_keys=True))
