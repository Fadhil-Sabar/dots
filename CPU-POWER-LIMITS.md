# CPU Power-Limit Configuration

Machine: AMD Ryzen 5 6600H (Rembrandt)

## Recommended daily configuration

The tested sweet spot is the `balanced` power profile with RyzenADJ limits of 30 W sustained, 40 W fast, 30 W slow, and an 85°C temperature ceiling.

```bash
powerprofilesctl set balanced

sudo ryzenadj \
  --stapm-limit=30000 \
  --fast-limit=40000 \
  --slow-limit=30000 \
  --tctl-temp=85
```

Expected CPU policy under `balanced`:

- Governor: `powersave`
- Boost: enabled
- Maximum frequency: approximately 4.57 GHz
- RyzenADJ STAPM limit: 30 W
- RyzenADJ fast limit: 40 W
- RyzenADJ slow limit: 30 W
- Temperature limit: 85°C

The governor should remain `powersave`; RyzenADJ is the sustained-load constraint while boost remains available for short workloads.

## Benchmark conclusion

The 30 W configuration was selected as the daily-driver sweet spot:

- Approximately 5% below stock performance
- Average load temperature around 82°C
- Maximum temperature around 85°C
- Stock reached approximately 100°C

Full benchmark results are stored at:

```text
~/tools/underwatt/SWEEP-RESULTS.md
~/ryzen-test-logs/sweep-20260711-141454/
```

## Persistence warning

The RyzenADJ command is not currently installed as a persistent systemd service or timer. RyzenADJ limits normally need to be reapplied after reboot, suspend, firmware resets, or other power-management events.

Check support/status with:

```bash
sudo ryzenadj -i
```

On this machine, monitoring may report an inability to initialize the power metric table. RyzenADJ indicated that this affects monitoring, not applying adjustments.

## Minimum-frequency override

A systemd service exists at:

```text
/etc/systemd/system/cpu-min-freq.service
```

It attempts to set the minimum CPU frequency to 412625 kHz (approximately 412 MHz):

```ini
[Unit]
Description=Set CPU min frequency to 400 MHz
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c "echo 412625 | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq"
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

The service is enabled, but `power-profiles-daemon` can subsequently restore the minimum to approximately 1.1 GHz.

An AC-unplug rule also exists at:

```text
/etc/udev/rules.d/90-cpu-min-freq.rules
```

The rule is intended to apply the 412625 kHz minimum when AC power is disconnected. Its current content appears to contain an unintended newline and may be malformed. The observed unplugged minimum remained approximately 1.1 GHz.

## Automatic desktop profiles

KDE PowerDevil configuration:

```text
~/.config/powerdevilrc
```

Configured profiles:

| Power state | Profile |
|---|---|
| AC | `performance` |
| Battery | `balanced` |
| Low battery | `power-saver` |

A manual profile selector is available at:

```text
~/.config/niri/scripts/power-profile.sh
```

It is bound to `Mod+P` in:

```text
~/.config/niri/config.kdl
```

## Verification commands

```bash
# Active desktop power profile
powerprofilesctl get

# Governor, frequency limits, and EPP
for policy in /sys/devices/system/cpu/cpufreq/policy*; do
  printf '%s: governor=%s min=%s max=%s epp=%s\n' \
    "$policy" \
    "$(cat "$policy/scaling_governor")" \
    "$(cat "$policy/scaling_min_freq")" \
    "$(cat "$policy/scaling_max_freq")" \
    "$(cat "$policy/energy_performance_preference" 2>/dev/null)"
done

# Boost state
cat /sys/devices/system/cpu/cpufreq/boost

# Minimum-frequency service
systemctl status cpu-min-freq.service

# RyzenADJ information (requires root)
sudo ryzenadj -i
```

## Other findings

- `cpupower` is installed, but `/etc/default/cpupower-service.conf` has no active frequency-limit configuration.
- No persistent TLP, tuned, thermald, auto-cpufreq, intel-undervolt, or throttled configuration was found.
- No explicit PL1/PL2, `max_perf_pct`, `no_turbo`, or boot-time CPU power-limit override was found.
