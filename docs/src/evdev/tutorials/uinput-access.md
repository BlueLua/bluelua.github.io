---
order: 6
title: UInput Access Setup
description:
  Configure permissions so Lua programs can create virtual input devices with
  uinput.
---

Creating virtual input devices requires `/dev/uinput` to exist and be writable
by the current user.

## Group setup

1. Create a `uinput` group:

   ```bash
   sudo groupadd --system uinput
   ```

1. Add your user to it:

   ```bash
   sudo usermod -aG uinput "$USER"
   ```

## Udev setup

1. Create a udev rule:

   ```bash
   echo 'KERNEL=="uinput", GROUP="uinput", MODE="0660",' \
     'OPTIONS+="static_node=uinput"' \
     | sudo tee /etc/udev/rules.d/99-uinput.rules
   ```

1. Load the kernel module:

   ```bash
   sudo modprobe uinput
   ```

1. Reload udev rules:

   ```bash
   sudo udevadm control --reload-rules
   sudo udevadm trigger
   ```

1. Start a new login session, or refresh the current shell group list:

   ```bash
   newgrp uinput
   ```

   > [!TIP]
   >
   > Logging out and back in is the cleanest way to pick up the new group.

## Verify

- Confirm the node exists and the group is correct:

  ```bash
  ls -l /dev/uinput
  ```

- Expected shape:

  ```text
  crw-rw---- 1 root uinput 10, <minor> <MMM DD HH:MM> /dev/uinput
  ```
