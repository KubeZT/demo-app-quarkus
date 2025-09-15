# KubeZT - Demo App Quarkus
![KubeZT Logo](https://kubezt-public.s3.us-gov-east-1.amazonaws.com/kubezt_logo_black.png)

<p align="center">
  <b>demo-app-quarkus</b> · A minimal Quarkus application built with <a href="https://nixos.org/">Nix</a> and deployed on the <a href="https://kubezt.com/">KubeZT</a> Zero Trust Kubernetes platform.
</p>

<p align="center">
  <img alt="Nix badge" src="https://img.shields.io/badge/Built%20With-Nix-blue?logo=nixos&logoColor=white">
  <img alt="Quarkus badge" src="https://img.shields.io/badge/Framework-Quarkus-red?logo=quarkus">
  <img alt="Kubernetes badge" src="https://img.shields.io/badge/Deployed%20On-KubeZT-4B0082?logo=kubernetes">
  <img alt="License" src="https://img.shields.io/badge/license-Apache--2.0-green">
</p>

---

## 🚀 What is This?

This project serves as a **starter template** for building secure, reproducible Quarkus applications using [Nix](https://nixos.org/) and deploying them to [KubeZT](https://kubezt.com) — a Zero Trust Kubernetes distribution purpose-built for secure environments, edge deployments, and minimal attack surfaces.

Use this project to:

- Learn how to structure a Nix-native Java app build
- Demo app deployment in hardened container environments
- Showcase KubeZT CI/CD and registry integration

---

## 🔐 Why Nix?

By using **Nix flakes** to build containers, we ensure:

| Benefit | Description |
|--------|-------------|
| ✅ **Reproducible Builds** | Same input, same output — guaranteed |
| 🔐 **Zero Trust by Default** | Build-time isolation and no implicit trust |
| 📦 **Minimal, Distroless Images** | No OS layer, just your app |
| 📉 **Near-Zero CVEs** | No shells, interpreters, or package managers included |
| 🧊 **Immutable Artifacts** | Fingerprinted images via SHA256 digests |
| ⚙️ **Multiple Targets** | Build both native and JVM-based images via `uberjar.nix` and `native.nix` |

---

## 🛠 Project Structure

```
demo-app-quarkus/
├── flake.nix          # Top-level Nix flake entrypoint
├── uberjar.nix        # Builds JVM-based Quarkus Uber JAR
├── native.nix         # Builds GraalVM native binary (optional)
├── src/               # Your Quarkus source code
└── pom.xml            # Standard Maven project descriptor
```

---

## 🏗️ Building and Pushing (via Nix)

To build and push your **distroless image** to a container registry (e.g., Harbor):

```bash
nix run .#uberjar-image.copyToRegistry
```

This will:
1. Build the image
2. Tag and push it to `registry.dev.kubezt.com/demo/demo-app-quarkus:uberjar-latest`

> ⚠️ Make sure your Docker config (`~/.docker/config.json`) contains credentials for the target registry.

---

## 📦 Local Dev Mode

You can still develop using Quarkus’s rich dev experience:

```bash
./mvnw quarkus:dev
```

Then open [http://localhost:8080/q/dev/](http://localhost:8080/q/dev/) to access the Quarkus Dev UI.

---


## 🔬 Packaging Options

| Type | Command | Output |
|------|---------|--------|
| Uber JAR | `nix build .#uberjar` | JVM-based executable JAR |
| Native Binary | `nix build .#native` | GraalVM native ELF binary |
| Container Image (JVM) | `nix build .#uberjar-image` | Docker/OCI image |
| Container Image (Native) | `nix build .#native-image` | Native container (GraalVM) |

---

## 📚 Related Links

- [Quarkus – Getting Started](https://quarkus.io/guides/getting-started)
- [Quarkus – Native Build Guide](https://quarkus.io/guides/building-native-image)
- [Nix – Reproducible Build System](https://nixos.org/)
- [KubeZT – Hardened Kubernetes for Zero Trust](https://kubezt.com)

---

## 🤝 About KubeZT

KubeZT is a secure-by-default Kubernetes distribution purpose-built for mission-critical environments.

Learn more: [https://KubeZT.com](https://KubeZT.com)

---

## 📜 License

This project is licensed under the [Apache 2.0 License](./LICENSE).
