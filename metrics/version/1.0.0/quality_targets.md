# v1.0.0 Quality Targets

## Stability Targets
- Session persistence across renderer transitions.
- GPU renderer failure fallback to CPU within <500 ms.
- No user-facing crash on shell resize/scroll bursts.

## AI Workflow Targets
- Deterministic command input latency under heavy output.
- No unexpected prompt corruption for fish + Starship.
- No startup blocking caused by shell integrations.

## Speed Targets
- Target 60+ FPS in normal workloads.
- Minimized CPU wake-up cycles in idle mode.
- Memory budget and allocation caps monitored per platform profile.
