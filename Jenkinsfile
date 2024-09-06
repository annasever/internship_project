pipeline {
    agent {
        label 'internship_project'
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }


    stages {
        stage('Checkout') {
            steps {
                git branch: 'develop', url: 'git@github.com:annasever/internship_project.git'
            }
        }

     stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t internship_project_image .'
                }
            }
        }

    stage('Run Docker Compose') {
        steps {
            script {
                sh 'docker-compose up -d'
                }
            }
        }
    }

    post {
        always {
            sh 'docker-compose down' 
        }
    }
}
