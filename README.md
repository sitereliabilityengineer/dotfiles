# Dotfiles con Nix Flakes + Home Manager

Configuración declarativa para dos entornos `x86_64-linux`, con módulos comunes y diferencias por máquina:

| Perfil de flake | Entorno | Usuario Linux | Directorio personal |
|---|---|---|---|
| `koteo@wsl` | WSL | `koteo` | `/home/koteo` |
| `koteo@generico` | Ubuntu/Linux nativo | `ircd` | `/home/ircd` |

**Importante:** el nombre del perfil de Home Manager no tiene por qué coincidir con el usuario del sistema. El perfil `koteo@generico` está configurado para `ircd` en el `flake.nix` actual. Antes de aplicar en otra máquina, revisa estos valores y los definidos en `hosts/common.nix`.

## Organización

- `flake.nix`: perfiles y entradas (`nixpkgs`, `home-manager`).
- `flake.lock`: revisiones exactas utilizadas para construir y desplegar. Debe versionarse en Git.
- `hosts/common.nix`: opciones compartidas y módulos importados.
- `hosts/wsl/home.nix`: configuración de WSL, incluido el servicio opcional `keep-awake`.
- `hosts/linux/home.nix`: configuración para Ubuntu/Linux nativo.
- `modules/shell/zsh.nix`: configuración de Zsh, aliases, historial y funciones.
- `modules/tools/cli.nix`: paquetes y aplicaciones de línea de comandos.
- `modules/services/background.nix`: servicio de usuario específico de WSL.
- `bin/check-dotfiles.sh`: construye y valida ambos perfiles sin activarlos.
- `bin/keep-awake.sh`: script auxiliar de WSL; revisar sus implicaciones antes de activarlo.

## Requisitos

1. Instalar Nix siguiendo la [documentación oficial](https://nixos.org/download/).
2. Habilitar las funciones `nix-command` y `flakes`. En la configuración de Nix correspondiente a la instalación (`/etc/nix/nix.conf` en muchas instalaciones), incluir:

   ```ini
   experimental-features = nix-command flakes
   ```

3. Trabajar como el usuario normal al que corresponde el perfil, **no como `root`**.
4. Clonar o copiar el repositorio a `~/dotfiles` y situarse dentro de él.
5. Tener Git disponible para trabajar con el flake y guardar los cambios.

## Instalación inicial

### WSL (`koteo`)

```bash
cd ~/dotfiles
./bin/check-dotfiles.sh
nix build --no-link '.#homeConfigurations."koteo@wsl".activationPackage'
```

Si `home-manager` ya está instalado:

```bash
home-manager switch --flake '.#koteo@wsl' -b backup
```

Si todavía no está instalado, como bootstrap:

```bash
nix run github:nix-community/home-manager -- switch -b backup --flake '.#koteo@wsl'
```

> **Compatibilidad de versiones:** el ejecutable que llega desde `github:nix-community/home-manager` puede no coincidir con la versión bloqueada en `flake.lock`. Para una instalación reproducible, usar un ejecutable Home Manager de la misma revisión que el input bloqueado. Si aparece un error de versión, no actualices el lock a ciegas: comprueba las revisiones antes.

### Ubuntu / Linux nativo (`ircd`)

```bash
cd ~/dotfiles
whoami                                 # debe mostrar ircd
./bin/check-dotfiles.sh
nix build --no-link '.#homeConfigurations."koteo@generico".activationPackage'
```

Comprobar el usuario y el directorio que espera el perfil:

```bash
nix eval --raw '.#homeConfigurations."koteo@generico".config.home.username'
printf '\n'
nix eval --raw '.#homeConfigurations."koteo@generico".config.home.homeDirectory'
printf '\n'
```

Los resultados esperados son `ircd` y `/home/ircd`. Si no coinciden con el equipo real, ajustar la configuración **antes** de activar.

Para la primera activación (con copias de archivos existentes):

```bash
cp -a ~/.zshrc ~/.zshrc.pre-home-manager 2>/dev/null || true
nix run github:nix-community/home-manager -- switch -b backup --flake '.#koteo@generico'
```

Si ya tienes `home-manager` instalado, utiliza preferentemente:

```bash
home-manager switch -b backup --flake '.#koteo@generico'
```

La opción `-b backup` conserva archivos preexistentes como `~/.zshrc.backup` antes de sustituirlos. **Si ya existe un `.backup`, consérvalo con otro nombre antes de repetir la activación**. Comprueba los archivos de respaldo y adapta cualquier personalización importante que no esté declarada en Nix.

## Cambios habituales

Después del primer despliegue, selecciona tu perfil (en los ejemplos, Ubuntu):

```bash
cd ~/dotfiles

git diff --check
./bin/check-dotfiles.sh
home-manager switch --flake '.#koteo@generico'
exec zsh
```

Para WSL, sustituir el perfil por `koteo@wsl`. Usa `-b backup` en `switch` cuando necesites proteger archivos preexistentes; no es necesario añadirlo por rutina si no hay conflictos.

**Flakes y Git:** los nuevos ficheros no rastreados pueden no estar disponibles al evaluar el flake. Inclúyelos con `git add` cuando corresponda. El aviso `Git tree ... is dirty` significa que hay modificaciones sin confirmar; por sí solo no es un fallo.

## Actualización del software instalado

Los paquetes declarados en `modules/tools/cli.nix` se obtienen de la revisión de Nixpkgs fijada en `flake.lock`. Ejecutar `home-manager switch` **sin actualizar el lock** vuelve a aplicar las versiones bloqueadas: no busca automáticamente las más recientes.

### Actualizar todas las dependencias

```bash
cd ~/dotfiles
cp -a flake.lock flake.lock.pre-update
nix flake update
git diff -- flake.lock
./bin/check-dotfiles.sh
home-manager switch --flake '.#koteo@generico'
```

En WSL, usar `'.#koteo@wsl'`. Tras comprobar el funcionamiento, versionar `flake.lock` junto con el resto de cambios. Recomendación: actualizar de forma controlada, no automáticamente en cada terminal o arranque.

### Actualizar únicamente Nixpkgs

En versiones actuales de Nix:

```bash
nix flake update nixpkgs
```

Puedes comprobar la sintaxis compatible con tu Nix mediante `nix flake update --help` (las opciones han cambiado entre versiones). El input Home Manager está configurado para seguir el mismo Nixpkgs, pero su propia revisión sigue fijada en el lock.

### Añadir o quitar un paquete

Modificar `modules/tools/cli.nix` y añadir o eliminar un atributo dentro de `home.packages`, después:

```bash
./bin/check-dotfiles.sh
home-manager switch --flake '.#koteo@generico'
```

No hace falta actualizar `flake.lock` solo por añadir un paquete que ya existe en la revisión bloqueada de Nixpkgs.

## Recuperación y mantenimiento

Ver generaciones de Home Manager:

```bash
home-manager generations
```

Para regresar a una generación anterior, seleccionar una ruta mostrada por ese comando y ejecutar su script `activate`; revisa la ruta concreta antes de hacerlo. Para revertir también la selección de paquetes en futuros despliegues, recupera la revisión correspondiente de `flake.lock` desde Git y vuelve a activar.

Si una actualización del lock no funciona **antes de aplicar**:

```bash
cp -a flake.lock.pre-update flake.lock
./bin/check-dotfiles.sh
```

Nix conserva las generaciones antiguas hasta que el recolector las elimina; no hagas una limpieza agresiva del store antes de verificar la actualización y el rollback.

## Particularidades de shell y seguridad

- La configuración actual usa Zsh, Oh My Zsh, Oh My Posh, FZF, Zoxide y herramientas CLI.
- El historial se guarda progresivamente y no se comparte inmediatamente entre pestañas.
- El archivo `~/.local_variables.env`, si existe, se carga desde Zsh: **no guardar contraseñas ni tokens en Git o en el Nix Store**.
- `vaultenv` carga ficheros desde `~/.vault` mediante `source`: deben ser archivos locales de confianza y con permisos adecuados.
- **Pendiente de corrección:** `modules/shell/zsh.nix` contiene un alias `chrome` con `--no-sandbox`. Eliminarlo antes de considerar cerrada la revisión de seguridad.
- **WSL:** `keep-awake` automatiza pulsaciones en Windows. Está fuera del perfil Linux nativo y debe revisarse frente a las políticas de uso correspondientes.
- Las configuraciones de usuario no administran por sí mismas los paquetes instalados con APT ni actualizan el sistema operativo Ubuntu.

## Validación y control de cambios

```bash
cd ~/dotfiles
git status --short
git diff --check
./bin/check-dotfiles.sh
```

Separar las modificaciones funcionales de las actualizaciones masivas de `flake.lock` facilita investigar problemas y revertir regresiones.
