podman run -d --name ml_devcontainer -v $(pwd):/home/vscode/workspace:Z localhost/ml_devcontainer:latest
podman exec -it --user root ml_devcontainer bash -c "rm -rf /home/vscode/.vscode-server/*"
podman exec -it --user root  ml_devcontainer bash
