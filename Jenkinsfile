pipeline {
    agent any
    environment {
        IMAGE_NAME = 'yp3yp3/to_do_list'
        email = 'yp3yp3@gmail.com'
        REMOTE_USER = 'ubuntu'
        REMOTE_HOST_STAGE = '172.31.40.99'
        REMOTE_HOST_PRODUCTION = '172.31.40.242'
        DB_HOST = '172.31.42.89'
        VERSION = ''
        ENVIRONMENT = ''

    }
    stages {
        stage('Deploy to staging') {
            when { changeset "stage_version.txt" }
            steps {
                script {
                    env.ENVIRONMENT = 'staging'
                    env.VERSION = readFile('stage_version.txt').trim()
                    echo "📦 Extracted version from file: ${VERSION}"
                    withCredentials([usernamePassword(credentialsId: 'DB_PASS', passwordVariable: 'DB_PASSWORD', usernameVariable: 'DB_USERNAME')]) {
                    sshagent (credentials: ['node1']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST_STAGE} \
                            "docker pull ${IMAGE_NAME}:${VERSION} && docker rm -f myapp && \
                            docker run -d --name myapp --restart unless-stopped \
                            -e DB_NAME=todo -e DB_USER=${DB_USERNAME} -e DB_PASSWORD=${DB_PASSWORD} -e DB_HOST=${DB_HOST} \
                            -p 5000:5000 ${IMAGE_NAME}:${VERSION}"
                         """
                }
            }
            }    
        }
        }
        stage('Deploy to production') {
            when { changeset "production_version.txt" }
            steps {
                script {
                    env.ENVIRONMENT = 'production'
                    env.VERSION = readFile('production_version.txt').trim()
                    echo "📦 Extracted version from file: ${VERSION}"
                    withCredentials([usernamePassword(credentialsId: 'DB_PASS', passwordVariable: 'DB_PASSWORD', usernameVariable: 'DB_USERNAME')]) {
                    sshagent (credentials: ['node1']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST_PRODUCTION} \
                            "docker pull ${IMAGE_NAME}:${VERSION} && docker rm -f myapp && \
                            docker run -d --name myapp --restart unless-stopped \
                            -e DB_NAME=todo -e DB_USER=${DB_USERNAME} -e DB_PASSWORD=${DB_PASSWORD} -e DB_HOST=${DB_HOST} \
                            -p 5000:5000 ${IMAGE_NAME}:${VERSION}"
                         """
                }
            }
            }    
        }
        }
        }
        
        post {
             failure {
                script {
                    def msg = "FAILED to deploy ${env.ENVIRONMENT} version ${env.VERSION} "
                
                slackSend(
                    channel: '#jenkins',
                    color: 'danger',
                    message: msg
                )
                
                emailext(
                    subject: "${JOB_NAME}.${BUILD_NUMBER} FAILED",
                    mimeType: 'text/html',
                    to: "$email",
                    body: msg
                )
            }
             }
            success {
                script {
                    def msg = "PASSED to deploy ${env.ENVIRONMENT} version ${env.VERSION}  http://stage.yp3yp3.online/"
                }
                slackSend(
                    channel: '#jenkins',
                    color: 'good',
                    message: msg
                )
                emailext(
                    subject: "${JOB_NAME}.${BUILD_NUMBER} PASSED",
                    mimeType: 'text/html',
                    to: "$email",
                    body: msg
                )
            }

        }
    }
