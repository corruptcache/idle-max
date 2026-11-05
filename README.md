# idle-maxing

A lightweight background daemon designed to fiercely audit your local hardware utilization, ensuring your machine stays strictly compliant with Sam Altman's 5% consumer DRAM philosophy.

## The Idle Maxing Manifesto

We need to talk about hardware efficiency. Sam Altman recently argued that having consumers hoard DRAM just to use it 5% of the time is "quite terrible" for global data centers, insisting everything should be maxed out in the cloud.

But let's keep things in perspective. Sam famously owns a multi-million dollar McLaren F1. I'm willing to bet good money that he doesn't drive that supercar more than 5% of the time. It sits parked, perfectly idle, while he preaches 100% utilization for everyone's hardware.

*Rules for thee, but parked hypercars for me.*

So I launched a movement: **Idle Maxing**. 

Thanks to this automated daemon running on your Linux setup, the moment your machine crosses that 5% weekly utilization threshold, you know it's time to idle. You close the lid, put the device on a shelf to rot, and spin up an entirely separate rig so the first machine can achieve 95% pure, uninterrupted idleness just like Sam's McLaren sitting in the garage.

Why hoard compute when you can idle max? Let's keep those data centers hungry.

---

## OS Compatibility
* **Linux** (Optimized for Arch-based distributions running Hyprland and standard desktop environments utilizing `libnotify`)

---

## Instructions to Setup the Daemon

1. **Clone or Download the Script**  
   Save the script to your local machine (e.g., as `idle-max.sh` inside your local bin or project directory):
   ```bash
   mkdir -p ~/.local/bin
   chmod +x ~/.local/bin/idle-max.sh
   ```

2. **Test the Daemon (Dry Run)**  
   Verify that your logging window, math, and notification hooks are firing properly by passing a mock usage argument:
   ```bash
   # Test low utilization (triggers the compliant McLaren success alert)
   ~/.local/bin/idle-max.sh 3

   # Test high utilization (triggers the critical violation warning)
   ~/.local/bin/idle-max.sh 42

   # Delete the log file after testing
   rm ~/.cache/idle_max_weekly.log
   ```

3. **Automate via Cron**  
   To ensure your machine is continuously audited on a rolling 7-day window, configure a cron job to run it every minute:
   ```bash
   crontab -e
   ```
   Add the following line to execute the audit every minute:
   ```cron
   * * * * * /bin/bash ~/.local/bin/idle-max.sh >/dev/null 2>&1
   ```
