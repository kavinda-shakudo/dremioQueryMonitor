import requests
import time
import base64
import json
import os
import subprocess
import pytz
import stat
from kubernetes import client, config
from datetime import datetime, timedelta

DREMIO_HOST = "http://dremio-client.hyperplane-dremio.svc.cluster.local:9047"
USERNAME = "admin"
PASSWORD = "Shakudo312!"
OUTPUT_DIR = "./dremio_views" 

SPACES_TO_SCAN = ["cs", "dremio", "hubspot_data", "marketing", "operations", "kk_test_space"]

est = pytz.timezone('US/Eastern')
current_time_est = datetime.now(est)

def get_token():
    resp = requests.post(f"{DREMIO_HOST}/apiv2/login", json={
        "userName": USERNAME,
        "password": PASSWORD
    })
    resp.raise_for_status()
    return resp.json()['token']

def clone_repo_if_needed():
    repo_url = "git@github.com:devsentient/dremio-backup.git"  # 👈 your private repo

    # If directory doesn't exist OR is not a git repo, clone it fresh
    git_dir = os.path.join(OUTPUT_DIR, ".git")
    
    if not os.path.isdir(git_dir):
        if os.path.exists(OUTPUT_DIR) and os.listdir(OUTPUT_DIR):
            print(f"[ERROR] Directory '{OUTPUT_DIR}' exists but is not a Git repo.")
            print("➡️  Either clear the directory or manually initialize it as a repo.")
            exit(1)
        
        print(f"[INFO] Cloning repo from {repo_url} into {OUTPUT_DIR}...")
        subprocess.run(["git", "clone", repo_url, OUTPUT_DIR], check=True)
    else:
        print("[INFO] Git repo already cloned.")

    # Always set remote origin (useful for ensuring correct SSH remote)
    subprocess.run(["git", "-C", OUTPUT_DIR, "remote", "set-url", "origin", repo_url], check=True)
    print("[INFO] Git remote origin set.")

def pull_latest_changes():
    print("[INFO] Pulling latest changes from remote...")
    try:
        subprocess.run(["git", "-C", OUTPUT_DIR, "pull", "--rebase"], check=True)
    except subprocess.CalledProcessError as e:
        print(f"[ERROR] Git pull failed: {e}")
        exit(1)

def setup_git_identity():
    subprocess.run(["git", "-C", OUTPUT_DIR, "config", "user.name", "Dremio Bot"], check=True)
    subprocess.run(["git", "-C", OUTPUT_DIR, "config", "user.email", "dremioBot@example.com"], check=True)

def write_ssh_keys(rsa_key_b64, rsa_key_pub_b64):
    ssh_dir = os.path.expanduser("~/.ssh")
    os.makedirs(ssh_dir, exist_ok=True)

    private_key_path = os.path.join(ssh_dir, "id_rsa")
    public_key_path = os.path.join(ssh_dir, "id_rsa.pub")

    # Decode and write private key
    with open(private_key_path, "wb") as f:
        f.write(base64.b64decode(rsa_key_b64))
    os.chmod(private_key_path, stat.S_IRUSR | stat.S_IWUSR)  # chmod 600

    # Decode and write public key
    with open(public_key_path, "wb") as f:
        f.write(base64.b64decode(rsa_key_pub_b64))

    print("[INFO] SSH keys written to ~/.ssh")

def setup_git_ssh():
    ssh_config_path = os.path.expanduser("~/.ssh/config")
    with open(ssh_config_path, "w") as f:
        f.write("""\
Host github.com
    IdentityFile ~/.ssh/id_rsa
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
""")
    os.chmod(ssh_config_path, stat.S_IRUSR | stat.S_IWUSR)

    os.environ["GIT_SSH_COMMAND"] = "ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no"
    print("[INFO] SSH config set up for GitHub access")


def list_views_in_space(token, path):
    headers = {"Authorization": f"_dremio{token}"}
    safe_path = "/".join(path)
    url = f"{DREMIO_HOST}/api/v3/catalog/by-path/{safe_path}"

    resp = requests.get(url, headers=headers)
    if resp.status_code == 404:
        print(f"[ERROR] Path not found: {'/'.join(path)}")
        return

    resp.raise_for_status()
    data = resp.json()
    items = data.get("children", [])

    for item in items:
        item_type = item.get('type')
        item_path = path + [item['path'][-1]] if 'path' in item else path
        name = "/".join(item_path)

        if item_type == "DATASET":
            dataset_id = item['id']
            detail_url = f"{DREMIO_HOST}/api/v3/catalog/{dataset_id}"
            detail_resp = requests.get(detail_url, headers=headers)
            detail_resp.raise_for_status()
            detail_data = detail_resp.json()
            sql = detail_data.get("sql", "[No SQL found]")

            # Print preview to console
            #print(f"📝 View: {name}  |  SQL: {sql[:80]}...")

            # Build file path
            file_path = os.path.join(OUTPUT_DIR, *item_path) + ".sql"
            os.makedirs(os.path.dirname(file_path), exist_ok=True)

            # Write SQL to file
            with open(file_path, "w") as f:
                f.write(sql)

        elif item_type in ["FOLDER", "CONTAINER"]:
            list_views_in_space(token, item_path)
def git_commit_if_changed():
    result = subprocess.run(
        ["git", "-C", OUTPUT_DIR, "status", "--porcelain"],
        stdout=subprocess.PIPE,
        text=True
    )

    # List to hold files that were modified or added
    changed_files = []

    if result.stdout.strip():  # If there are changes
        print("\n[INFO] Changes detected. Files modified:")
        
        # Collect and print the changed files
        for line in result.stdout.splitlines():
            status, file_path = line.split(" ", 1)
            if status in ["M", "A"]:  # M for modified, A for added
                changed_files.append(file_path)
                print(f"- {file_path}")  # Print changed files in the console

        # Stage all changes
        subprocess.run(["git", "-C", OUTPUT_DIR, "add", "."], check=True)

        # Commit changes
        commit_msg = f"🔄 Update Dremio views @ {current_time_est.strftime('%Y-%m-%d %H:%M:%S')} EST"
        subprocess.run(["git", "-C", OUTPUT_DIR, "commit", "-m", commit_msg], check=True)

        # Push to remote
        subprocess.run(["git", "-C", OUTPUT_DIR, "push"], check=True)
        
    else:
        print("[INFO] No changes to commit. Git is up to date ✅")
    
    # If files were changed, print them at the very bottom
    if changed_files:
        print("\n[INFO] Files that were changed:")
        for file in changed_files:
            print(f"- {file}")

if __name__ == "__main__":

    try:
        config.load_incluster_config()  # Use load_incluster_config() if running inside a pod
    except Exception as e:
        exit(1)

    namespace = 'hyperplane-pipelines'  # Replace with your namespace
    secret_name = 'dremio-backup-deploy-key'  # Replace with your secret name


    v1 = client.CoreV1Api()

    # Fetch the secret
    try:
        #print(f"Fetching secret '{secret_name}' from namespace '{namespace}'...")
        secret = v1.read_namespaced_secret(secret_name, namespace)
        #print(f"Successfully fetched secret: {secret_name}")
    except Exception as e:
        print(f"Error fetching secret: {e}")
        exit(1)

    # Retrieve and decode the 'id_rsa.pub' key only if it exists
    rsa_key_pub = secret.data.get('id_rsa.pub')
    rsa_key = secret.data.get('id_rsa')

    # Setup SSH keys for Git access
    if rsa_key and rsa_key_pub:
        write_ssh_keys(rsa_key, rsa_key_pub)
        setup_git_ssh()
    else:
        print("[ERROR] RSA keys not found in secret. Exiting.")
        exit(1)

    # Clone repo and ensure remote origin is set
    clone_repo_if_needed()
    # Pull latest changes to avoid conflicts
    pull_latest_changes()
    # Reset working directory so Git doesn't detect unchanged files
    subprocess.run(["git", "-C", OUTPUT_DIR, "reset", "--hard", "origin/main"], check=True)
    
    setup_git_identity() 

    token = get_token()
    print("\n[INFO] Scanning specific spaces for saved views and exporting to Git...")

    for space in SPACES_TO_SCAN:
        print(f"\n[INFO] Scanning space: {space}")
        list_views_in_space(token, path=[space])

    # After processing the views, commit changes to Git if any
    git_commit_if_changed()

    print("\n[INFO] Done ✅")
