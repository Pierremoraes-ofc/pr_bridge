# Tuning API (`pr_lib.fivem.tuning`)

A API de tuning traz métodos utilitários fáceis (Sugar Syntax) englobados na API de Properties. É ótimo para sistemas de oficina (Mecânicas).

### Modificações Rápidas e Manutenção
```lua
local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

pr_lib.fivem.tuning.repair(vehicle) -- Repara, limpa e alinha chassi

pr_lib.fivem.tuning.setPlate(vehicle, "PIERRE99")

pr_lib.fivem.tuning.setFuel(vehicle, 100.0)

pr_lib.fivem.tuning.setMod(vehicle, 11, 3) -- ModType (Engine), ModIndex (Level 4)

pr_lib.fivem.tuning.setNeon(vehicle, true, { 255, 0, 0 }) -- Neon vermelho ligado

pr_lib.fivem.tuning.setXenon(vehicle, true, 3) -- Xenon ligado, Cor 3
```

### Snapshot e Restore (Backup)
Uma funcionalidade incrível para mecânicos. Salve uma "foto" atual das peças do veículo antes do jogador começar a mexer. Caso ele não compre as peças, simplesmente dê *restore*.

```lua
-- Salva a configuracao original no comeco do script
local originalProps = pr_lib.fivem.tuning.snapshot(vehicle)

-- (...) Jogador mexeu e resolveu cancelar a compra (...)

-- Volta pro original
pr_lib.fivem.tuning.restore(vehicle, originalProps)
```
