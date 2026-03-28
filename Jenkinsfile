pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-2'
    }

    stages {
        stage('Debug') {
            steps {
                echo 'Pipeline is executing'
                sh 'pwd'
                sh 'ls -la'
            }
        }

        stage('Set AWS Credentials') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'jenkins-test'
                ]]) {
                    sh '''
                        aws sts get-caller-identity
                    '''
                }
            }
        }

        stage('Initialize Terraform') {
            steps {
                sh '''
                    terraform version
                    terraform init
                '''
            }
        }

        stage('Plan Terraform') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'jenkins-test'
                ]]) {
                    sh '''
                        terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                input message: 'Approve Terraform Apply?', ok: 'Deploy'
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'jenkins-test'
                ]]) {
                    sh '''
                        terraform apply -auto-approve tfplan
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform deployment completed successfully!'
        }
        failure {
            echo 'Terraform deployment failed!'
        }
    }
}
