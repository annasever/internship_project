pipeline {
    agent {
        label 'internship_project'
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        POSTGRES_DB           = credentials('mydatabase')
        POSTGRES_USER         = credentials('myuser')
        POSTGRES_PASSWORD     = credentials('mypassword')
        MONGO_INITDB_DATABASE = credentials('my_mongo_database')
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')
        BACKEND_IMAGE = 'annasever/backend:latest'
        FRONTEND_IMAGE = 'annasever/frontend:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/develop']], extensions: [], userRemoteConfigs: [[credentialsId: 'jenkins-git-user', url: 'git@github.com:annasever/internship_project.git']])
            }
        }

        stage('Build Backend Docker Image') {
            steps {
                dir('backend') {
                    script {
                        try {
                            sh 'docker build -t $BACKEND_IMAGE .'
                        } catch (Exception e) {
                            error "Failed to build backend Docker image: ${e.message}"
                        }
                    }
                }
            }
        }

        stage('Build Frontend Docker Image') {
            steps {
                dir('frontend') {
                    script {
                        try {
                            sh 'docker build -t $FRONTEND_IMAGE .'
                        } catch (Exception e) {
                            error "Failed to build frontend Docker image: ${e.message}"
                        }
                    }
                }
            }
        }

        stage('Push Docker Images to DockerHub') {
            steps {
                script {
                    try {
                        docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_credentials') {
                            sh 'docker push $BACKEND_IMAGE'
                            sh 'docker push $FRONTEND_IMAGE'
                        }
                    } catch (Exception e) {
                        error "Failed to push Docker images to DockerHub: ${e.message}"
                    }
                }
            }
        }

        stage('Run Docker Compose') {
            steps {
                script {
                    try {
                        sh 'docker-compose up -d'
                    } catch (Exception e) {
                        error "Failed to run Docker Compose: ${e.message}"
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                try {
                    sh 'docker-compose down'
                } catch (Exception e) {
                    echo "Failed to run docker-compose down: ${e.message}"
                }
            }
        }
    }
}

