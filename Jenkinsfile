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
        BACKEND_IMAGE         = 'annasever/backend'
        FRONTEND_IMAGE        = 'annasever/frontend'
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

     stage('Build Backend Image if Changed') {
            when {
                changeset "**/src/main/**"
            }
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        docker.build("${BACKEND_IMAGE}:latest", '.').push('latest')
                    }
                }
            }
        }

        stage('Build Frontend Image if Changed') {
            when {
                changeset "**/frontend/**" 
            }
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        docker.build("${FRONTEND_IMAGE}:latest", './frontend').push('latest')
                    }
                }
            }
        }

        stage('Deploy Services') {
            steps {
                sh 'docker-compose pull'
                sh 'docker-compose up -d'  
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
