import json
import pathlib
import sys
import urllib.error
import urllib.request

base_url = sys.argv[1].rstrip("/")
evidence_path = pathlib.Path(sys.argv[2])
allowed_names = {"Minnie", "Margaret", "Myrtle"}
samples = []

for index in range(20):
    request = urllib.request.Request(f"{base_url}/v1/generate_name", headers={"Accept": "application/json"})
    with urllib.request.urlopen(request, timeout=5) as response:
        content_type = response.headers.get("Content-Type", "")
        payload = json.loads(response.read())
        if response.status != 200:
            raise SystemExit(f"FAIL: generated-name request {index + 1} returned {response.status}")
        if not content_type.startswith("application/json"):
            raise SystemExit(f"FAIL: generated-name response has Content-Type {content_type!r}")
        if set(payload) != {"name"} or payload["name"] not in allowed_names:
            raise SystemExit(f"FAIL: generated-name response did not match the documented contract: {payload!r}")
        samples.append(payload["name"])

try:
    urllib.request.urlopen(f"{base_url}/v1/missing", timeout=5)
except urllib.error.HTTPError as error:
    if error.code != 404:
        raise SystemExit(f"FAIL: unknown route returned HTTP {error.code}, expected 404") from error
else:
    raise SystemExit("FAIL: unknown route unexpectedly succeeded")

result = {
    "path": "GET /v1/generate_name",
    "requests": len(samples),
    "status": 200,
    "content_type": "application/json",
    "allowed_values": sorted(allowed_names),
    "observed_values": samples,
    "unknown_route_status": 404,
}
evidence_path.parent.mkdir(parents=True, exist_ok=True)
evidence_path.write_text(f"{json.dumps(result, indent=2)}\n")
print(f"PASS: 20 JSON responses matched the name contract; unknown route returned HTTP 404")
