# Dotfiles Nix Flakes + Home Manager

Configuración declarativa para `koteo@wsl` y `koteo@generico` (`x86_64-linux`).
Las dos configuraciones importan `hosts/common.nix`; solo WSL activa `keep-awake`.

## Estructura

- `flake.nix` / `flake.lock`: entradas y versiones bloqueadas.
- `hosts/common.nix`: configuración compartida entre ambos perfiles.
- `hosts/wsl/home.nix`: diferencias de WSL y servicio opcional de usuario.
- `hosts/linux/home.nix`: configuración Linux genérica.
- `modules/shell/zsh.nix`: Zsh, Oh My Zsh, historial, binds y funciones.
- `modules/tools/cli.nix`: CLI, tmux, fzf, neovim y herramientas.
- `modules/services/background.nix`: servicio de usuario específico de WSL.
- `bin/keep-awake.sh`: implementación del servicio anterior.

## Instalación

Instalar Nix según las instrucciones oficiales: https://nixos.org/download/.
Habilitar `nix-command` y `flakes` en la configuración de Nix si fuera necesario.

Para el primer despliegue, con `home-manager` todavía ausente:

```bash
nix run github:nix-community/home-manager -- switch --flake '.#koteo@wsl'
# O para Linux: .#koteo@generico
```

> En un bootstrap desde `github:` la versión del ejecutable puede no coincidir con el lock.
> Para evitarlo, conviene instalar Home Manager compatible con la revisión bloqueada,
> o utilizar un `nix run` que apunte a esa misma revisión. Una vez activado, usar el
> `home-manager` instalado en el perfil.

## Cambio seguro

```bash
cd ~/dotfiles
cp -p ~/.zsh_history ~/.zsh_history.backup
# Antes de hacer switch, revisar el diff y validar ambos perfiles:
./bin/check-dotfiles.sh
nix build --no-link '.#homeConfigurations."koteo@wsl".activationPackage'
home-manager switch --flake '.#koteo@wsl'
exec zsh
```

Para Linux genérico, sustituir `koteo@wsl` por `koteo@generico`.

Si se añade un **nuevo fichero** a un flake ubicado en Git, incluirlo en el índice
(`git add hosts/common.nix`, por ejemplo) antes de evaluar el flake. Los cambios
sin commit en archivos ya rastreados pueden producir el aviso `Git tree is dirty`.

## Actualizaciones y rollback

```bash
nix flake update       # Actualiza flake.lock: revisar el diff
./bin/check-dotfiles.sh
home-manager generations
```

No actualizar automáticamente en equipos de trabajo. Para retroceder, consultar
`home-manager generations` y ejecutar el script `activate` de la generación anterior
(`…/home-manager-generation/activate`) después de inspeccionar la ruta.

## Historial / terminal

- `INC_APPEND_HISTORY`: persiste comandos sin esperar al cierre.
- `SHARE_HISTORY` deshabilitado: las pestañas no comparten inmediatamente comandos.
- Inicio/Fin: mapeadas varias secuencias xterm comunes; si MobaXterm usa otras,
  inspeccionarlas con `cat -v` y ajustar el módulo de Zsh.
- `Ctrl+C` dentro de IPython normalmente **interrumpe**, no sale; salir con `exit` o `Ctrl+D`.

## Notas de seguridad

- El antiguo alias `chrome` con `--no-sandbox` se ha quitado.
- `vaultenv` ejecuta mediante `source` scripts locales: conservar permisos y
  controlar su contenido; no incluir credenciales en Git ni en Nix Store.
- `keep-awake` sigue activado únicamente en WSL como en el original; revisar que
  su uso cumple las políticas de tu organización. El script usa Scroll Lock,
  aunque su comentario antiguo mencionaba F15.
- `home.nix.100826` se conserva como copia histórica: no forma parte de los imports.
