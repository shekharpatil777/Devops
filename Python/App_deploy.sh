import os

def deploy_app(app_name="my_app"):
    deploy_path = f"/tmp/{app_name}"
    if not os.path.exists(deploy_path):
        os.makedirs(deploy_path)
        with open(os.path.join(deploy_path, "app.py"), "w") as f:
            f.write("# Your application code here")
        print(f"Application '{app_name}' deployed to {deploy_path}")
    else:
        print(f"Application '{app_name}' already exists at {deploy_path}")

if __name__ == "__main__":
    deploy_app()