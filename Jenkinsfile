pipeline {
    agent any

    environment {
        // Path to your SSH private key for Ansible
        SSH_PRIVATE_KEY = '/home/ec2-user/.ssh/petra-hs-project.pem'
        INVENTORY_FILE = 'inventory.ini'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout your Terraform + Ansible repo
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Generate Inventory') {
            steps {
                // Create inventory.ini dynamically from Terraform outputs
                script {
                    def build_ip = sh(script: "terraform output -raw build_server_ip", returnStdout: true).trim()
                    def deploy_ip = sh(script: "terraform output -raw deploy_server_ip", returnStdout: true).trim()

                    writeFile file: "${env.INVENTORY_FILE}", text: """
                    [build_servers]
                    ${build_ip} ansible_user=ec2-user ansible_ssh_private_key_file=${env.SSH_PRIVATE_KEY}

                    [deploy_servers]
                    ${deploy_ip} ansible_user=ec2-user ansible_ssh_private_key_file=${env.SSH_PRIVATE_KEY}
                    """
                }
            }
        }

        stage('Run Ansible - Build Server') {
            steps {
                sh "ansible-playbook -i ${env.INVENTORY_FILE} build-server.yml"
            }
        }

        stage('Run Ansible - Deploy Server') {
            steps {
                sh "ansible-playbook -i ${env.INVENTORY_FILE} deploy-server.yml"
            }
        }
    }

    post {
        always {
            echo "Pipeline finished."
        }
    }
}

