alias kubectl='u8s kubectl'
alias helm='u8s helm'

alias u='u8s'
alias uk='u8s kubectl'
alias uh='u8s helm'


# kubectl "current context"
function kcc() {
  echo "Cluster: ${U8S_CONTEXT}"
  echo "Namespace: ${U8S_NAMESPACE:-default}"
}

# kubectl "use context"
function kuc() {
  export U8S_CONTEXT="$1"
  kcc
}

# kubectl "context default namespace"
# Usage: `kcdfns rook-ceph` - will set default namespace to 'rook-ceph'
function kcdfns() {
  # kubectl config set-context --current --namespace=$1
  export U8S_NAMESPACE="$1"
  kcc
}


##
# ----- kubectl ----------
alias k='kubectl'
alias kdl='kubectl delete'
alias klg='kubectl logs'
alias klf='kubectl logs -f'
alias kaf='kubectl apply -f'
alias kdlf='kubectl delete -f'

# ----- kubectl get ----------
alias kg='kubectl get'
alias kgp='kubectl get pods -o wide'
alias kgd='kubectl get deploy -o wide'
alias kgs='kubectl get svc -o wide'
alias kgn='kubectl get nodes -o wide'

# ----- kubectl describe ----------
alias kd='kubectl describe'
alias kdp='kubectl describe pods'
alias kdd='kubectl describe deploy'
alias kds='kubectl describe svc'
alias kdn='kubectl describe nodes'

# ----- Kubectl config ------
alias kc='kubectl config'
alias kgc='kubectl config get-contexts'
# alias kuc='kubectl config use-context'
