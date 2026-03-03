#!/bin/bash
#==============================================================================
# ☁️ Cloud Security — 75+ Tools Installer
# HackNow Red Team Toolbox
#==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

ensure_base

install_multicloud() {
    print_section "☁️ Multi-Cloud Audit Tools (6 tools)"
    ensure_python
    pip_install "scoutsuite"    "scoutsuite"
    pip_install "prowler"       "prowler"
    pip_install "cloudsploit"   "cloudsploit"
    pip_install "steampipe"     "steampipe"
    git_install "CloudMapper"   "https://github.com/duo-labs/cloudmapper.git" "Cloud"
    git_install "cartography"   "https://github.com/lyft/cartography.git" "Cloud"
}

install_aws() {
    print_section "🟠 AWS Attack & Audit (10 tools)"
    ensure_python
    pip_install "awscli"       "awscli"
    pip_install "pacu"         "pacu"
    pip_install "boto3"        "boto3"
    git_install "enumerate-iam" "https://github.com/andresriancho/enumerate-iam.git" "Cloud/AWS"
    git_install "S3Scanner"    "https://github.com/sa7mon/S3Scanner.git" "Cloud/AWS"
    git_install "CloudBrute"   "https://github.com/0xsha/CloudBrute.git" "Cloud/AWS"
    git_install "WeirdAAL"     "https://github.com/carnal0wnage/weirdAAL.git" "Cloud/AWS"
    ensure_go
    go_install "cloudfox"      "github.com/BishopFox/cloudfox@latest"
    git_install "aws_consoler" "https://github.com/NetSPI/aws_consoler.git" "Cloud/AWS"
    git_install "Endgame"      "https://github.com/DavidDikworworker/endgame.git" "Cloud/AWS"
}

install_azure() {
    print_section "🔵 Azure & Entra ID Attack (8 tools)"
    ensure_python
    pip_install "roadrecon"    "roadtools"
    git_install "ROADtools"    "https://github.com/dirkjanm/ROADtools.git" "Cloud/Azure"
    git_install "AADInternals" "https://github.com/Gerenios/AADInternals.git" "Cloud/Azure"
    git_install "MicroBurst"   "https://github.com/NetSPI/MicroBurst.git" "Cloud/Azure"
    git_install "Stormspotter" "https://github.com/Azure/Stormspotter.git" "Cloud/Azure"
    git_install "GraphRunner"  "https://github.com/dafthack/GraphRunner.git" "Cloud/Azure"
    pip_install "azure-cli"    "azure-cli"
    print_info "AzureHound — https://github.com/BloodHoundAD/AzureHound"
}

install_gcp() {
    print_section "🟢 GCP Attack (5 tools)"
    git_install "GCPBucketBrute" "https://github.com/RhinoSecurityLabs/GCPBucketBrute.git" "Cloud/GCP"
    git_install "gcp_enum"     "https://github.com/RhinoSecurityLabs/GCP-IAM-Privilege-Escalation.git" "Cloud/GCP"
    ensure_python
    pip_install "gcloud"       "google-cloud-sdk"
    print_info "gcloud CLI — https://cloud.google.com/sdk/docs/install"
    print_info "ScoutSuite ham GCP ni qo'llab-quvvatlaydi"
}

install_container() {
    print_section "🐳 Container & Kubernetes (10 tools)"
    apt_install "docker"       "docker.io"     "docker"        "docker"
    # Trivy
    ensure_python
    git_install "trivy"        "https://github.com/aquasecurity/trivy.git" "Cloud/K8s"
    print_info "Trivy binary: https://github.com/aquasecurity/trivy/releases"
    git_install "kube-hunter"  "https://github.com/aquasecurity/kube-hunter.git" "Cloud/K8s"
    pip_install "kube-hunter"  "kube-hunter"
    git_install "kubescape"    "https://github.com/kubescape/kubescape.git" "Cloud/K8s"
    git_install "CDK"          "https://github.com/cdk-team/CDK.git" "Cloud/K8s"
    git_install "deepce"       "https://github.com/stealthcopter/deepce.git" "Cloud/K8s"
    git_install "peirates"     "https://github.com/inguardians/peirates.git" "Cloud/K8s"
    git_install "kubectl-who-can" "https://github.com/aquasecurity/kubectl-who-can.git" "Cloud/K8s"
    print_info "kube-bench: https://github.com/aquasecurity/kube-bench"
}

main() {
    if [[ "$1" == "--all" ]]; then
        print_menu_header "CLOUD SECURITY" "☁️"
        install_multicloud; install_aws; install_azure; install_gcp; install_container
        print_summary "☁️ Cloud Security"
        return
    fi

    print_menu_header "CLOUD SECURITY" "☁️"
    echo -e "  ${WHITE}${BOLD}OS:${NC} $OS_NAME ($OS_TYPE)"
    echo ""

    show_section_menu "☁️ Cloud Security" \
        install_multicloud  "☁️   Multi-Cloud Audit (6 tools)" \
        install_aws         "🟠  AWS Attack & Audit (10 tools)" \
        install_azure       "🔵  Azure & Entra ID (8 tools)" \
        install_gcp         "🟢  GCP Attack (5 tools)" \
        install_container   "🐳  Container & Kubernetes (10 tools)"

    print_summary "☁️ Cloud Security"
}

main "$@"
