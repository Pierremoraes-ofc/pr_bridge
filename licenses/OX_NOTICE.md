# ox_lib source attribution

The legacy-specific portions of `imports/` contain utility source from the local ox_lib 3.38.0 distribution, based on https://github.com/overextended/ox_lib. Original copyright notices remain in applicable source files. As of 2026-10-10, 32 import files are native-routing adapters and all nine duplicated `bridge/compat/ox_services/` sources have been removed. Native vehicle property modules retain their own existing upstream attribution. The LGPL-3.0-or-later license is included in `ox_lib-LGPL-3.0.txt`, together with the incorporated `GPL-3.0.txt` obtained from https://www.gnu.org/licenses/gpl-3.0.txt.

This compatibility layer is maintained by PR Bridge and is not endorsed by Overextended. The original ox_lib frontend is not included. Source hashes and the installed baseline are recorded in `docs/ox_compatibility_inventory.json`.

The 33 translation data files in `bridge/compat/ox_locales/` are also incorporated from that distribution under the same project license.

Behavioral modifications to utility imports: callback lifecycle/source validation and logger provider require resolution. Some otherwise unchanged imports differ only in their trailing newlines; original and provider hashes are retained separately in the inventory.

Service integration now delegates to canonical PR version, ACE, vehicle, streaming and progress APIs. Progress interruption/cleanup/props and generic state validation are implemented in native PR modules; the compatibility boundary retains legacy event names and authorization policy. Explicit version checks use the native PR GitHub checker. Native PR loading, result/signature adapters, UI ownership coordination and legacy export publishing are integration code. This is not an endorsement or a guarantee of runtime parity by Overextended.
