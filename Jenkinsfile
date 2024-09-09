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
        GITHUB_WEBHOOK_SECRET = credentials('webhook_secret_credentials')
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/develop']], extensions: [], userRemoteConfigs: [[credentialsId: 'jenkins-git-user', url: 'git@github.com:annasever/internship_project.git']])
            }
        }

        stage('Build Backend Image if Dockerfile Changed') {
            when {
                expression {
                    def changes = sh(script: "git diff --name-only HEAD~1 HEAD", returnStdout: true).trim()
                    return changes.contains('Dockerfile')
                }
            }
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        def backendImage = docker.build("${BACKEND_IMAGE}:latest", '.')
                        backendImage.push('latest')
                    }
                }
            }
        }

        stage('Build Frontend Image if Dockerfile Changed') {
            when {
                expression {
                    def changes = sh(script: "git diff --name-only HEAD~1 HEAD", returnStdout: true).trim()
                    return changes.contains('frontend/Dockerfile')
                }
            }
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        def frontendImage = docker.build("${FRONTEND_IMAGE}:latest", './frontend')
                        frontendImage.push('latest')
                    }
                }
            }
        }

        stage('Deploy Services') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        sh 'docker-compose pull'
                        sh 'docker-compose up -d'
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
            sh 'docker image prune -f'
        }
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Deployment failed. Check the logs.'
        }
    }
}

