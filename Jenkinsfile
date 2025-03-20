pipeline {
    agent any

    parameters {
        booleanParam(name: 'PLAN_TERRAFORM', defaultValue: false, description: 'Check to plan Terraform changes')
        booleanParam(name: 'APPLY_TERRAFORM', defaultValue: false, description: 'Check to apply Terraform changes')
        booleanParam(name: 'DESTROY_TERRAFORM', defaultValue: false, description: 'Check to destroy Terraform changes')
    }

    stages {
        stage('Clone Repository') {
            steps {
                deleteDir() // Clean workspace before cloning
                git branch: 'main', url: 'https://github.com/jayakumarm06/Devops-project-01.git'
                sh "ls -lart"
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rwagh']]) {
                    dir('development') {
                        sh 'echo "================= Terraform Init =================="'
                        sh 'rm -rf .terraform' // Cleanup previous runs
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            when {
                expression { params.PLAN_TERRAFORM }
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rwagh']]) {
                    dir('development') {
                        sh 'echo "================= Terraform Plan =================="'
                        sh 'terraform plan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.APPLY_TERRAFORM }
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rwagh']]) {
                    dir('development') {
                        sh 'echo "================= Terraform Apply =================="'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.DESTROY_TERRAFORM }
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-rwagh']]) {
                    dir('development') {
                        sh 'echo "================= Terraform Destroy =================="'
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }
}
