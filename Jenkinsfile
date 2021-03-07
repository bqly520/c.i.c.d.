pipeline {
    agent any
    stages {
        stage('Health Check') {
            steps {
                echo 'Health Checking...'
            }
        }
        stage('Run Ansible-Playbook for minikube install') {
            steps {
                echo 'Building minikube'
            }
        }
        stage('Validation of deployments') {
            steps {
                echo 'Validating...'
            }
        }
    }
}