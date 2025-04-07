WILCO_ID="`cat .wilco`"
CODESPACE_BACKEND_HOST=$(curl -s "${ENGINE_BASE_URL}/api/v1/codespace/backendHost?codespaceName=${CODESPACE_NAME}&portForwarding=${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}" | jq -r '.codespaceBackendHost')
CODESPACE_BACKEND_URL="https://${CODESPACE_BACKEND_HOST}"
export ENGINE_EVENT_ENDPOINT="${ENGINE_BASE_URL}/users/${WILCO_ID}/event"

# Update engine that codespace started for user
curl -L -X POST "${ENGINE_EVENT_ENDPOINT}" -H "Content-Type: application/json" --data-raw "{ \"event\": \"github_codespace_started\" }"

# Export backend envs when in codespaces
echo "export CODESPACE_BACKEND_HOST=\"${CODESPACE_BACKEND_HOST}\"" >> ~/.bashrc
echo "export CODESPACE_BACKEND_URL=\"${CODESPACE_BACKEND_URL}\"" >> ~/.bashrc
echo "export CODESPACE_WDS_SOCKET_PORT=443" >> ~/.bashrc

# Export welcome prompt in bash:
echo "printf \"\n\n☁️☁️☁️️ Wilco: Develop in the Cloud ☁️☁️☁️\n\"" >> ~/.bashrc

nohup bash -c "cd /wilco-agent && node agent.js &" >> /tmp/agent.log 2>&1

curl -sL https://get.garden.io/install.sh | bash
echo "export PATH=\$PATH:~/.garden/bin" >> ~/.bashrc

sudo apt-get update && sudo apt-get install -y xdg-utils
minikube start
echo "eval $(minikube docker-env)" >> ~/.bashrc
