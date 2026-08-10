# ❄️ Nix Dotfiles (Home Manager)

Este repositorio contiene la configuración declarativa de mi entorno de terminal y herramientas de desarrollo utilizando **Nix** y **Home Manager** (vía Flakes). 

La arquitectura es modular, lo que permite reutilizar el 90% de la configuración (Zsh, alias, herramientas SRE) y aplicar perfiles específicos dependiendo de si la máquina es un entorno WSL o un servidor Linux tradicional.

---

## 🚀 1. Instalación de Nix (Standalone)

Si estás en una máquina completamente nueva (Ubuntu, Debian, etc.) que aún no tiene Nix, ejecuta el instalador oficial en modo multiusuario:

```bash
sh <(curl -L [https://nixos.org/nix/install](https://nixos.org/nix/install)) --daemon
```

Como este repositorio utiliza la arquitectura moderna de **Flakes**, es necesario habilitarla en el motor de Nix. Crea el directorio de configuración y añade las *features* experimentales:

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Cierra tu terminal y abre una nueva para que el entorno cargue las variables de Nix.

---

## 📥 2. Preparar el Repositorio

Clona el repositorio en tu directorio *home* y entra en él:

```bash
git clone <URL-DE-TU-REPO> ~/dotfiles
cd ~/dotfiles
```

---

## 💻 3. Primer Despliegue (Bootstrap)

La primera vez que despliegas, el comando `home-manager` aún no está instalado en el sistema. Utilizaremos `nix run` para invocarlo temporalmente desde el repositorio oficial y aplicar nuestro perfil.

Ejecuta **solo uno** de los siguientes comandos dependiendo de la máquina en la que te encuentres:

### Opción A: Entorno de trabajo (WSL)
Inyecta el *toolkit* de SRE completo y levanta los servicios específicos para Windows (como el *keep-awake* de Teams vía PowerShell).

```bash
nix run home-manager/master -- switch --flake .#koteo@wsl
```

### Opción B: Linux Genérico (Servidores, VMs, Portátiles)
Inyecta el entorno puro de terminal (Zsh, direnv, Docker, k9s, OpenTofu, etc.) omitiendo cualquier servicio o dependencia que requiera Windows/WSL.

```bash
nix run home-manager/master -- switch --flake .#koteo@generico
```

---

## 🛠️ 4. Flujo de trabajo diario (Actualizaciones)

Una vez realizado el primer despliegue, el binario de `home-manager` ya estará disponible de forma permanente en tu `$PATH`. 

Para aplicar cualquier cambio futuro en la configuración, recuerda la **regla de oro de Nix Flakes**: el motor ignora los archivos que no estén rastreados por Git.

1. Edita los archivos necesarios en `modules/` o `hosts/`.
2. Añade los cambios al *stage* de Git:
   ```bash
   git add .
   ```
3. Aplica la configuración (ajusta el sufijo `@wsl` o `@generico` según corresponda):
   ```bash
   home-manager switch --flake .#koteo@wsl
   ```

---

## 📂 5. Estructura del Repositorio

*   **`flake.nix`**: Punto de entrada principal. Define los perfiles (`@wsl`, `@generico`) y mapea los *hosts*.
*   **`hosts/`**: Contiene los archivos `home.nix` que actúan como "índices". Importan únicamente los módulos necesarios para esa máquina concreta.
*   **`modules/`**: El núcleo de la configuración, dividido lógicamente (ej. `shell/zsh.nix`, `tools/cli.nix`). Evita la duplicidad de código.
*   **`bin/`**: Scripts locales físicos en bash/python. Son consumidos por Nix mediante `builtins.readFile` para empaquetarlos de forma inmutable y ejecutarlos vía Systemd.
