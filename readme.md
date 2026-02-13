Automated RHEL 9 Web Infrastructure on AWS
This project demonstrates a production-ready, automated deployment of a Red Hat Enterprise Linux (RHEL) web server within a custom AWS VPC using Terraform (Infrastructure as Code).

🏗️ Architecture Overview
The infrastructure is built from the ground up to ensure network isolation and high availability within the us-east-1 region.

Custom VPC: A dedicated Virtual Private Cloud for secure resource isolation.

Public Subnet: Configured with an Internet Gateway to allow external web traffic.

RHEL 9 EC2 Instance: A hardened Linux server running Apache (httpd).

Elastic IP (EIP): A fixed, permanent public IP address to ensure the portfolio remains accessible across restarts.

Multi-Layer Security: Integrated AWS Security Groups (Network Layer) and RHEL firewalld (OS Layer) to protect the instance.

🛠️ Key Technical Features
Automated Provisioning: Uses user_data scripts to automatically install Apache and configure the OS firewall upon launch.

ICMP Enabled: Security groups are configured to allow ICMP (Ping) for real-time connectivity testing.

State Management: Developed with a clean .gitignore to protect sensitive Terraform state and AWS credentials.